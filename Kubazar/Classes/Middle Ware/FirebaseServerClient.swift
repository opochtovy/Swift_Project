//
//  FirebaseServerClient.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Alamofire
import AlamofireObjectMapper
import PromiseKit

enum AppError: Error {
    
    case nilFound
}

enum AuthenticatorState {
    
    case unauthorized
    case authorized
}

enum StoreKeys {
    
    static let isUserAuthorized = "isUserAuthorized"
    static let authVerificationID = "authVerificationID"
    static let authToken = "Authentication-Token"
    static let signInPassword = "Sign-In-Password"
}

class FirebaseServerClient {
    
    typealias BaseCompletion = (_ success: Bool, _ error: Error?) -> Void
    
    static let AuthenticatorStateDidChangeNotification = "AuthenticatorStateDidChangeNotification"
    static let FCMTokenDidPutNotification = "FCMTokenDidPutNotification"
    
    var sessionManager: SessionManager
    var fcmToken: String = ""
    var isJustAfterAuth: Bool = false
    
    public var state : AuthenticatorState? {
        
        didSet {
            
            UserDefaults.standard.set(state == .authorized, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            
            let notification = Notification(name: Notification.Name(rawValue: FirebaseServerClient.AuthenticatorStateDidChangeNotification))
            NotificationCenter.default.post(notification)
        }
    }
    
    var authToken: String? {
        
        get {
            
            var password = ""
            do {
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: StoreKeys.authToken, accessGroup: KeychainConfiguration.accessGroup)
                password = try passwordItem.readPassword()
            }
            catch {
                fatalError("Error reading password from keychain - \(error)")
            }
            return password
        }
        set {
            
            do {
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: StoreKeys.authToken, accessGroup: KeychainConfiguration.accessGroup)
                if let newValue = newValue {
                    
                    try passwordItem.savePassword(newValue)
                }
            }
            catch {
                fatalError("Error saving password to keychain - \(error)")
            }
        }
    }
    
    var signInPassword: String? {
        
        get {
            
            var password = ""
            do {
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: StoreKeys.signInPassword, accessGroup: KeychainConfiguration.accessGroup)
                password = try passwordItem.readPassword()
            }
            catch {
                fatalError("Error reading password from keychain - \(error)")
            }
            return password
        }
        set {
            
            do {
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: StoreKeys.signInPassword, accessGroup: KeychainConfiguration.accessGroup)
                if let newValue = newValue {
                    
                    try passwordItem.savePassword(newValue)
                }
            }
            catch {
                fatalError("Error saving password to keychain - \(error)")
            }
        }
    }
    
    //MARK: - LyfeCycle
    
    init() {
        sessionManager = SessionManager()
    }
    
    //MARK: - Private functions
    
    private func setState() {
        
        self.state = UserDefaults.standard.bool(forKey: StoreKeys.isUserAuthorized) ? .authorized : .unauthorized
    }
    
    public func setStateOfCurrentUser() {
    
        self.setState()
        
        if self.state == .authorized, let user = Auth.auth().currentUser {
            
            print("user.uid =", user.uid)
            print("user.email =", user.email ?? "no email")
            print("user.photoURL =", user.photoURL ?? "no photoURL")
            print("user.displayName =", user.displayName ?? "no displayName")
            print("user.phoneNumber =", user.phoneNumber ?? "no phone number")
        }
    }
    
    public func getUserDisplayName() -> String {
        
        if let user = Auth.auth().currentUser, let displayName = user.displayName {
            
            return displayName
        }
        
        return "no displayName"
    }
    
    public func getUserEmail() -> String {
        
        if let email = Auth.auth().currentUser?.email {
            
            return email
        }
        
        return "no email"
    }
    
    public func getUserPhone() -> String {
        
        if let phone = Auth.auth().currentUser?.phoneNumber {
            
            return phone
        }
        
        return "no phone number"
    }
    
    private func getProfileImageName(displayName: String) -> String {
        
        let user = Auth.auth().currentUser
        var emailPart = ""
        if let user = user {
            
            emailPart = displayName
            
            if emailPart.count == 0, let userEmail = user.email {
                
                let emailComponents = userEmail.components(separatedBy: "@")
                if let emailComponent = emailComponents.first {
                    
                    emailPart = emailComponent
                }
            }
        }
        if emailPart.count == 0 {
            
            emailPart = "username"
        }
        emailPart = emailPart.appending("_photo.jpg")
        
        return emailPart
    }
    
    public func getProfilePhotoURL() -> URL? {
        
        let photoURL = Auth.auth().currentUser?.photoURL
        return photoURL
    }
    
    public func getUserId() -> String {
        
        if let uid = Auth.auth().currentUser?.uid {
            
            return uid
        }
        
        return "no user id"
    }
    
    public func activateCurrentUser() {
        
        if let currentUser = Auth.auth().currentUser {
            
            let user = User().initWithFirebaseUser(firebaseUser: currentUser)
            HaikuManager.shared.currentUser = user
        }
    }
    
    //MARK: - Firebase
    
    public func signOut(completionHandler:@escaping (String?, Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
            self.state = .unauthorized
            
            UserDefaults.standard.set(false, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            
            completionHandler(nil, true)
            // in completion block -> self.client.sessionManager.adapter = SessionTokenAdapter(sessionToken: "")
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            completionHandler(signOutError.localizedDescription, false)
        }
    }
    
    public func sendPhoneNumber(phoneNumber: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                
                completionHandler(error.localizedDescription, false)
                return
            }
            guard let verificationID = verificationID else { return }
            
            UserDefaults.standard.set(verificationID, forKey: StoreKeys.authVerificationID)
            UserDefaults.standard.synchronize()
            
            completionHandler(nil, true)
        }
    }
    
    public func signInWithPhoneNumber(verificationCode: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.signInWithPhoneAuthProvider(verificationCode: verificationCode).then { (_) -> Promise<Void> in
            
            return self.getToken()
            
            }.then { (_) -> Promise<Void> in
                
                return self.putFCMToken()
                
            }.then { (_) -> Void in
                
                completionHandler(nil, true)
                
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func signInWithPhoneAuthProvider(verificationCode: String) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let verificationID = UserDefaults.standard.value(forKey: StoreKeys.authVerificationID)
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    
                    if let error = error {
                        
                        reject(error)
                    }
                }
                
                UserDefaults.standard.set(true, forKey: StoreKeys.isUserAuthorized)
                UserDefaults.standard.synchronize()
                fulfill(())
            }
        }
    }
    
    public func signInWithEmailPassword(email: String, password: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.signInWithEmailAuthProvider(email: email, password: password).then { (_) -> Promise<Void> in
            
            self.isJustAfterAuth = true
            self.state = .authorized
            self.signInPassword = password
            return self.getToken()
            
            }.then { (_) -> Promise<Void> in
                
                return self.putFCMToken()
                
            }.then { (_) -> Void in
                
                completionHandler(nil, true)
                
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func signInWithEmailAuthProvider(email: String, password: String) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil, let error = error {
                    
                    reject(error)
                }
                
                UserDefaults.standard.set(true, forKey: StoreKeys.isUserAuthorized)
                UserDefaults.standard.synchronize()
                
                fulfill(())
            }
        }
    }
    
    public func linkEmailPasswordToAccount(email: String, password: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let user = Auth.auth().currentUser {
            
            user.link(with: credential) { (user, error) in
                
                if error != nil {
                    
                    if let error = error {
                        
                        completionHandler(error.localizedDescription, false)
                        return
                    }
                }
                
                self.signInPassword = password
                completionHandler(nil, true)
            }
        }        
    }
    
    public func resetPassword(email: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                
                completionHandler(error.localizedDescription, false)
                return
            }
            
            completionHandler(nil, true)
        }
    }
    
    public func createProfileChangeRequest(displayName: String, photoURL: URL?, completionHandler:@escaping (String?, Bool) -> ()) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges { (error) in
            
            if error != nil {
                
                if let error = error {
                    
                    completionHandler(error.localizedDescription, false)
                    return
                }
            }
            
            self.isJustAfterAuth = true
            self.state = .authorized
            
            completionHandler(nil, true)
        }
    }
    
    public func updatePhotoURL(photoURL: URL?) -> Promise<URL?> {
        
        return Promise { fulfill, reject in
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = photoURL
            
            changeRequest?.commitChanges { (error) in
                
                if error != nil {
                    
                    if let error = error {
                        
                        reject(error)
                    }
                }
                
                fulfill(photoURL)
            }
        }
    }
    
    public func updateUserProfile(displayName: String, email: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        let user = Auth.auth().currentUser
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        
        changeRequest?.commitChanges { (error) in
            
            if error != nil {
                
                if let error = error {
                    
                    completionHandler(error.localizedDescription, false)
                    return
                }
            }
            
            user?.updateEmail(to: email, completion: { (error) in
                
                if error != nil {
                    
                    if let error = error {
                        
                        completionHandler(error.localizedDescription, false)
                        return
                    }
                }
                
                completionHandler(nil, true)
            })
        }
    }
    
    public func updateUserPassword(password: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        let user = Auth.auth().currentUser
        user?.updatePassword(to: password) { (error) in
            
            if error != nil {
                
                if let error = error {
                    
                    completionHandler(error.localizedDescription, false)
                    return
                }
            }
            self.signInPassword = password
            completionHandler(nil, true)
        }
    }
    
    public func uploadPhotoToUserProfile(displayName: String, photoData: Data, completionHandler:@escaping (URL?, Bool) -> ()) {
        
        let emailPart = self.getUserDisplayName()
        let photoPathName = "profileImages/" + emailPart
        
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(photoPathName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _: StorageUploadTask = photoRef.putData(photoData, metadata: metadata) { metadata, error in
            
            if error != nil {
                
                completionHandler(nil, false)
                return
                
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                if let downloadURL = metadata!.downloadURL() {
                    
                    completionHandler(downloadURL, true)
                } else {
                    
                    completionHandler(nil, true)
                }
                return
            }
        }
    }
    
    public func getToken() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let user = Auth.auth().currentUser
            if let user = user {
                
                user.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                    
                    if let idToken = idToken {
                        
                        self.authToken = idToken
                        self.sessionManager.adapter = SessionTokenAdapter(sessionToken: idToken)
                        fulfill(())
                        
                    } else if let error = error {
                        
                        reject(error)
                    }
                })
            } else {
                print()
            }
        }
    }
    
    //MARK: - Alamofire
    
    public func addFCMToken(completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.putFCMToken().then { (_) -> Void in
            
            completionHandler(nil, true)
            
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func putFCMToken() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            if self.fcmToken.count == 0 {
                print("Error")
            }
            
            let bodyParameters: [String: String] = ["token": self.fcmToken]
            print("bodyParameters =", bodyParameters)
            let request = AuthenticationRouter.addFCMToken(bodyParameters: bodyParameters)
            
            self.sessionManager.request(request).validate().response(completionHandler: { dataResponse in
                
                if let error = dataResponse.error {
                    
                    reject(error)
                    return
                }
                
                if let currentUser = Auth.auth().currentUser {
                    
                    let user = User().initWithFirebaseUser(firebaseUser: currentUser)
                    HaikuManager.shared.currentUser = user
                }
                fulfill(())
            })
        }
    }
    
    public func setUserAvatar(imageData: Data, progressCompletion: @escaping (_ percent: Float) -> Void, completionHandler:@escaping (URL?, Bool) -> ()) {
        
        self.uploadUserAvatar(imageData: imageData, progressCompletion: progressCompletion).then { downloadURL -> Promise<URL?> in
            
            self.updatePhotoURL(photoURL: downloadURL)
            
            }.then { downloadURL -> Void in
                
                completionHandler(downloadURL, true)
                
            }.catch { error in
                
                completionHandler(nil, false)
        }
    }
    
    public func uploadUserAvatar(imageData: Data, progressCompletion: @escaping (_ percent: Float) -> Void) -> Promise<URL?> {
        
        return Promise { fulfill, reject in
            
            var imageName = self.getUserDisplayName()
            let user = Auth.auth().currentUser
            if let userDisplayName = user?.displayName {
                
                imageName = self.getProfileImageName(displayName: userDisplayName)
            }
            let multipartFormData = MultipartFormData()
            multipartFormData.append(imageData, withName: imageName, fileName: imageName, mimeType: "image/jpeg")
            
            guard let data = try? multipartFormData.encode() else {
                print("Fail")
                reject(NSError(domain:"", code:1001, userInfo:nil))
                return
            }
            
            let request = AuthenticationRouter.uploadUserAvatar(contentType: multipartFormData.contentType, multipartFormData: data)
            self.sessionManager.request(request).validate().responseJSON(completionHandler: { (response) in
                
                guard response.result.isSuccess else {
                    
                    if let error = response.error {
                        
                        reject(error)
                    }
                    return
                }
                
                let dict = response.result.value as? Dictionary<String, Any>
                if let dict = dict {
                    let imgDict = dict["img"] as? Dictionary<String, String>
                    if let imgDict: Dictionary<String, String> = imgDict {
                        
                        let url = imgDict["url"]
                        if let url = url {
                            
                            let downloadURL = URL.init(string: url)
                            print("result url =", url)
                            fulfill(downloadURL)
                            return
                        }
                    }
                }
                
                print("SUCCESS")
                fulfill(nil)
            })
        }
    }
    
    public func getHaikus(page: Int, perPage: Int, sort: Int, filter: Int, completionHandler:@escaping ([Haiku], Bool) -> ()) {
        
        self.getHaikusPromise(page: page, perPage: perPage, sort: sort, filter: filter).then { haikus -> Void in
            
                completionHandler(haikus, true)
            
            }.catch { error in
                
                completionHandler([], false)
        }
    }
    
    public func reauthenticateUser() -> Promise<Void> {
        
        return Promise {  fulfill, reject in
            
            let user = Auth.auth().currentUser
            if let password = self.signInPassword, let email = user?.email {
                
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                user?.reauthenticate(with: credential) { error in
                    if let error = error {
                        
                        reject(error)
                    } else {
                        
                        fulfill(())
                    }
                }
            } else {
                print()
            }
        }
    }
    
    public func getHaikusPromise(page: Int, perPage: Int, sort: Int, filter: Int) -> Promise<[Haiku]> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized {
                
                let sortValue = sort == 0 ? "date" : "likes"
                let urlParameters : [String: Any] = ["page": page,
                                                        "perPage": perPage,
                                                        "sort": sortValue]
                
                var request = HaikuRouter.getAllHaikus(urlParameters: urlParameters)
                if let value = BazarVM.BazarFilter(rawValue: filter) {
                    
                    switch value {
                    case .mine: request = HaikuRouter.getPersonalHaikus(urlParameters: urlParameters)
                    case .active: request = HaikuRouter.getActiveHaikus(urlParameters: urlParameters)
                    default: request = HaikuRouter.getAllHaikus(urlParameters: urlParameters)
                    }
                }
                
                self.sessionManager.request(request).validate().responseArray{(response: DataResponse <[Haiku]>) in
                    
                    switch response.result {
                        
                    case .success(let haikus):
                        
                        print("SUCCESS : haikus count =", haikus.count)
                        fulfill(haikus)
                        
                    case .failure(let error):
                        
                        reject(error)
                    }
                }
                
            }
        }
    }
    
    public func likeHaiku(haiku: Haiku, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.likeHaikuPromise(haiku: haiku).then { () -> Void in
            
            completionHandler(nil, true)
            
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func likeHaikuPromise(haiku: Haiku) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized {
                
                let request = HaikuRouter.likeHaiku(haikuId: haiku.id)
                self.sessionManager.request(request).validate().responseObject { (response: DataResponse<Haiku>) in
                    
                    switch response.result {
                        
                    case .success(let newHaiku):
                        
                        print("Like : newHaiku.likesCount =", newHaiku.likesCount)
                        print("Like : newHaiku.likes =", newHaiku.likes)
                        haiku.likes = newHaiku.likes
                        haiku.likesCount = newHaiku.likesCount
                        fulfill(())
                        
                    case .failure(let error):
                        
                        reject(error)
                    }
                }
            }
        }
    }
    
    public func deleteHaiku(haikuId: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.deleteHaikuPromise(haikuId: haikuId).then { () -> Void in
            
            completionHandler(nil, true)
            
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func deleteHaikuPromise(haikuId: String) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized {
                
                let request = HaikuRouter.deleteHaiku(haikuId: haikuId)
                
                self.sessionManager.request(request).validate().response(completionHandler: { response in
                    
                    if let error = response.error {
                        
                        reject(error)
                        
                    } else {
                        
                        let statusCode = response.response?.statusCode
                        if statusCode == 204 {

                            print("SUCCESS")
                            fulfill(())
                        } else {
                            reject(NSError(domain:"", code:1001, userInfo:nil))
                        }
                    }
                })
            }
        }
    }
    
    public func changeHaikuAccess(haiku: Haiku, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.changeHaikuAccessPromise(haiku: haiku).then { () -> Void in
            
            completionHandler(nil, true)
            
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func changeHaikuAccessPromise(haiku: Haiku) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized {
                
                let accessValue = haiku.published ? "private" : "public"
                let bodyParameters: [String: String] = ["access": accessValue]
                let request = HaikuRouter.changeHaikuAccess(haikuId: haiku.id, bodyParameters: bodyParameters)
                self.sessionManager.request(request).validate().responseObject { (response: DataResponse<Haiku>) in
                    
                    switch response.result {
                        
                    case .success(let newHaiku):
                        
                        print("Publish/Unpublish : newHaiku.likesCount =", newHaiku.likesCount)
                        print("Publish/Unpublish : newHaiku.likes =", newHaiku.likes)
                        print("Publish/Unpublish : newHaiku.access =", newHaiku.access)
                        haiku.published = newHaiku.published
                        haiku.likes = newHaiku.likes
                        haiku.likesCount = newHaiku.likesCount
                        haiku.access = newHaiku.access
                        
                        fulfill(())
                        
                    case .failure(let error):
                        
                        reject(error)
                    }
                }
            }
        }
    }
    
    //MARK: Friends
    
    public func fetchFriends(phones: [String]) -> Promise<[User]> {
        
        return Promise {  fulfill, reject in
            
            let bodyParams: [String : Any] = ["phones" : phones]
            let request = FriendsRouter.getFriends(bodyParameters: bodyParams)

            self.sessionManager.request(request).validate().responseArray(keyPath: "users") { (response: DataResponse<[User]>) in
                
                switch response.result {
                case .success(let friends):
                    
                    fulfill(friends)
                    
                case .failure(let error):
                    
                    reject(error)
                }
            }
        }
    }
    
    public func postInvite(onPhoneNumber phoneNumber: String) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            guard phoneNumber.count > 5 else { reject(AppError.nilFound); return }
            let bodyParams: [String : Any] = ["phone" : phoneNumber]
            
            let request = FriendsRouter.inviteFriend(bodyParameters: bodyParams)
            self.sessionManager.request(request).validate().responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    fulfill(())
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    //MARK: Haikus Creation
    
    public func postSingleHaiku(_ bodyParameters: Parameters) -> Promise<Haiku> {
        
        return Promise {  fulfill, reject in
            
            let request = HaikuRouter.createSingleHaiku(bodyParameters: bodyParameters)
            
            self.sessionManager.request(request).validate().responseObject(completionHandler: { (response: DataResponse<Haiku>) in
                
                switch response.result {
                case .success(let haiku):
                    fulfill(haiku)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    public func postMultiHaiku(_ bodyParameters: Parameters) -> Promise<Haiku> {
        
        return Promise {  fulfill, reject in
            
            let request = HaikuRouter.createMultiHaiku(bodyParameters: bodyParameters)
            
            self.sessionManager.request(request).validate().responseObject(completionHandler: { (response: DataResponse<Haiku>) in
                
                switch response.result {
                case .success(let haiku):
                    fulfill(haiku)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    public func postMultiHaiku(_ haiku: Haiku) -> Promise<Haiku> {
        
        return Promise {  fulfill, reject in
            
            guard let firstLineText = haiku.fields[0].text else { reject(AppError.nilFound); return}
            let texts: [String] = [firstLineText]
            let friends = haiku.friends.flatMap({ (friend) -> String? in
                return friend.id
            })
            var font: [String: Any] = [:]
            font["color"]   = haiku.decorator.fontHexColor
            font["family"]  = haiku.decorator.fontFamily
            font["size"]    = haiku.decorator.fontSize
            
            let bodyParams: [String : Any] = ["text"    : texts,
                                              "font"    : font,
                                              "friends" : friends]
            
            let request = HaikuRouter.createMultiHaiku(bodyParameters: bodyParams)
            
            self.sessionManager.request(request).responseObject(completionHandler: { (response: DataResponse<Haiku>) in
                
                switch response.result {
                case .success(let haiku):
                    fulfill(haiku)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    public func postHaikuImage(_ imageData: Data, _ haiku: Haiku) -> Promise<Haiku> {
        
        return Promise { fulfill, reject in
            
            let multipartFormData = MultipartFormData()
            multipartFormData.append(imageData, withName: "file", fileName: "fileName.jpg", mimeType: "image/jpeg")
            
            guard let data = try? multipartFormData.encode() else { reject(AppError.nilFound); return }
            let request = imageRouter.addImage(argument: haiku.id, contentType: multipartFormData.contentType, multipartFormData: data)
            
            
            self.sessionManager.request(request).validate().responseObject(completionHandler: { (response: DataResponse<Haiku>) in
                
                switch response.result {
                case .success(let haiku):
                    fulfill(haiku)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    public func putLine(arguments: Parameters, bodyparameters: Parameters) -> Promise<Haiku> {
        
        return Promise { fulfill, reject in
            
            let request = HaikuRouter.addLine(arguments: arguments, bodyParameters: bodyparameters)
            
            self.sessionManager.request(request).validate().responseObject(completionHandler: { (response: DataResponse<Haiku>) in
                switch response.result {
                case .success(let haiku):
                    fulfill(haiku)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    //MARK: - Notifications
    
    public func fetchNotifications(page: Int, perPage: Int) -> Promise<[KBNotification]> {
        
        return Promise {  fulfill, reject in
            
            let urlParameters : [String: Any] = ["page": page,
                                                 "perPage": perPage]
            let request = NotificationRouter.getNotifications(urlParameters: urlParameters)
            
            self.sessionManager.request(request).validate().responseArray{(response: DataResponse <[KBNotification]>) in
                
                switch response.result {
                case .success(let notifications):
                    
                    fulfill(notifications)
                    
                case .failure(let error):
                    
                    reject(error)
                }
            }
        }
    }
}
