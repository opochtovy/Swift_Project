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

enum AuthenticatorState {
    
    case unauthorized
    case authorized
}

class FirebaseServerClient {
    
    static let AuthenticatorStateDidChangeNotification = "AuthenticatorStateDidChangeNotification"
    
    public var state : AuthenticatorState? {
        
        didSet {
            
            UserDefaults.standard.set(state == .authorized, forKey: "isUserAuthorized")
            UserDefaults.standard.synchronize()
            
            let notification = Notification(name: Notification.Name(rawValue: FirebaseServerClient.AuthenticatorStateDidChangeNotification))
            NotificationCenter.default.post(notification)
        }
    }
    
    //MARK: - Public functions
    
    public func setStateOfCurrentUser() {
    
        self.setState()
        
        if self.state == .authorized, let user = Auth.auth().currentUser {
            
            print("user.uid =", user.uid)
            print("user.email =", user.email ?? "no email")
            print("user.photoURL =", user.photoURL ?? "no photoURL")
            print("user.displayName =", user.displayName ?? "no displayName")
        }
    }
    
    public func signOut() {
        
        do {
            try Auth.auth().signOut()
            self.state = .unauthorized
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    public func sendPhoneNumber(phoneNumber: String, completionHandler:@escaping (Bool) -> ()) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                // TODO: show error
                print(error)
                completionHandler(false)
                return
            }
            guard let verificationID = verificationID else { return }
            print("verificationID =", verificationID)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.set(true, forKey: "isUserAuthorized")
            UserDefaults.standard.synchronize()
            
            completionHandler(true)
        }
    }
    
    public func signInWithPhoneNumber(verificationCode: String, completionHandler:@escaping (Bool) -> ()) {
        
        let verificationID = UserDefaults.standard.value(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                
                completionHandler(false)
                return
            }
            
            // User is signed in
            if let user = user {
                
                print("Phone number: \(user.phoneNumber ?? "nil")")
                let userInfo: Any? = user.providerData[0]
                print(userInfo ?? "no user info")
                completionHandler(true)
            }
        }
    }
    
    public func signInWithEmailPassword(email: String, password: String, completionHandler:@escaping (String?, Bool) -> ()) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                
                if let error = error {
                    
                    completionHandler(error.localizedDescription, false)
                    return
                }
            }
            
            completionHandler(nil, true)
        }
    }
    
    public func linkEmailPasswordToAccount(email: String, password: String, completionHandler:@escaping (Bool) -> ()) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let user = Auth.auth().currentUser {
            
            user.link(with: credential) { (user, error) in
                
                if error != nil {
                    
                    do {
                        try Auth.auth().signOut()
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    completionHandler(false)
                    return
                }
                
                completionHandler(true)
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
    
    public func updateUserProfile(displayName: String, photoURL: URL?, completionHandler:@escaping (Bool) -> ()) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges { (error) in
            
            if error != nil {
                
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    public func uploadPhotoToUserProfile(displayName: String, photoData: Data, completionHandler:@escaping (URL?, Bool) -> ()) {
        
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
    
    //MARK: - Private functions

    private func setState() {
        
        self.state = UserDefaults.standard.bool(forKey: "isUserAuthorized") ? .authorized : .unauthorized
    }
}
