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
import PromiseKit

enum AuthenticatorState {
    
    case unauthorized
    case authorized
}

enum StoreKeys {
    
    static let isUserAuthorized = "isUserAuthorized"
    static let authVerificationID = "authVerificationID"
    static let authToken = "Authentication-Token"
}

class FirebaseServerClient {
    
    typealias BaseCompletion = (_ success: Bool, _ error: Error?) -> Void
    
    static let AuthenticatorStateDidChangeNotification = "AuthenticatorStateDidChangeNotification"
    
    var sessionManager: SessionManager
    var deviceToken: Data = Data()
    
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
    
    //MARK: - Firebase
    
    public func signOut(completionHandler:@escaping (String?, Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
            self.state = .unauthorized
            
            UserDefaults.standard.set(false, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            
            completionHandler(nil, true)
            // in completion block -> self.client.sessionManager.adapter = nil
            
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
                
                return self.putDeviceToken()
                
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
                
                // User is signed in
                if let user = user {
                    
                    print("Phone number: \(user.phoneNumber ?? "nil")")
                    let userInfo: Any? = user.providerData[0]
                    print(userInfo ?? "no user info")
                }
                fulfill(())
            }
        }
    }
    
    public func signInWithEmailPassword(email: String, password: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.signInWithEmailAuthProvider(email: email, password: password).then { (_) -> Promise<Void> in
            
            self.state = .authorized
            return self.getToken()
            
            }.then { (_) -> Promise<Void> in
                
                return self.putDeviceToken()
                
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
                    
                    do {
                        try Auth.auth().signOut()
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    if let error = error {
                        
                        completionHandler(error.localizedDescription, false)
                        return
                    }
                }
                
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
    
    private func getToken() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let user = Auth.auth().currentUser
            if let user = user {
                
                user.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                    
                    if let idToken = idToken {
                        
                        self.authToken = idToken
                        fulfill(())
                        
                    } else if let error = error {
                        
                        reject(error)
                    }
                })
            }
        }
    }
    
    //MARK: - Alamofire
    
    public func addDeviceToken(completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.putDeviceToken().then { (_) -> Void in
            
            completionHandler(nil, true)
            
            }.catch { error in
                
                completionHandler(error.localizedDescription, false)
        }
    }
    
    private func putDeviceToken() -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            let bodyParameters: [String: String] = ["token": self.deviceToken.base64EncodedString()]
            let request = AuthenticationRouter.addDeviceToken(bodyParameters: bodyParameters)
            
            self.sessionManager.request(request).response(completionHandler: { dataResponse in
                
                if let error = dataResponse.error {
                    
                    reject(error)
                
                } else {
                    
                    fulfill(())
                }
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
            self.sessionManager.request(request).responseJSON(completionHandler: { (response) in
                
                guard response.result.isSuccess else {
                    
                    reject(NSError(domain:"", code:1001, userInfo:nil))
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
    
    // responseData
    
    public func getUserAvatar(completionHandler:@escaping (Data?, Bool) -> ()) {
        
        self.downloadUserAvatar().then { imageData -> Void in
            
            completionHandler(imageData, true)
            
            }.catch { error in
                
                completionHandler(nil, false)
        }
    }
    
    public func downloadUserAvatar() -> Promise<Data?> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized, let user = Auth.auth().currentUser, let userPhotoURL = user.photoURL {
                
                let request = AuthenticationRouter.downloadProfileImage(url: userPhotoURL)
                self.sessionManager.request(request).responseData(completionHandler: { (response) in
                    
                    if let error = response.error {
                        
                        reject(error)
                    }
                    print("user.photoURL =", user.photoURL ?? "no photoURL")
                    print("response.result.description.count =", response.result.description.count)
                    print("response.data?.count =", response.data?.count)
                    fulfill(response.data)
                })
            }
        }
    }
    
    // responseImage
/*
    public func getUserAvatar(completionHandler:@escaping (UIImage?, Bool) -> ()) {
        
        self.downloadUserAvatar().then { image -> Void in
            
            completionHandler(image, true)
            
            }.catch { error in
                
                completionHandler(nil, false)
        }
    }
    
    public func downloadUserAvatar() -> Promise<UIImage?> {
        
        return Promise { fulfill, reject in
            
            if self.state == .authorized, let user = Auth.auth().currentUser, let userPhotoURL = user.photoURL {
                
                print("user.photoURL =", user.photoURL ?? "no photoURL")
                
                let request = AuthenticationRouter.downloadProfileImage(url: userPhotoURL)
                self.sessionManager.request(request).responseImage(completionHandler: { (response) in
                    
                    guard let image = response.result.value else {
                        
                        if let error = response.error {
                            
                            reject(error)
                        }
                        return
                    }
                    fulfill(image)
                })
            }
        }
    }
*/
}
