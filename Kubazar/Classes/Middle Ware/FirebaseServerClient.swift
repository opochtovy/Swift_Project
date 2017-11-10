//
//  FirebaseServerClient.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Firebase

enum AuthenticatorState {
    
    case unauthorized
    case authorized
}

class FirebaseServerClient {
    
    static let AuthenticatorStateDidChangeNotification = "AuthenticatorStateDidChangeNotification"
    
    public var state : AuthenticatorState?
    
    //MARK: - Public functions
    
    public func setStateOfCurrentUser() {
    
        self.setState()
    }
    
    public func sendPhoneNumber(completionHandler:@escaping (Bool) -> ()) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+375297509711", uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                // TODO: show error
                print(error)
                completionHandler(false)
                return
            }
            guard let verificationID = verificationID else { return }
            print("verificationID =", verificationID)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.synchronize()
            
            completionHandler(true)
        }
    }
    
    public func signInWithPhoneNumber(verificationCode: String, completionHandler:@escaping (Bool) -> ()) {
        
        let verificationID = UserDefaults.standard.value(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
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
    
    //MARK: - Private functions

    private func setState() {
        
        let user = Auth.auth().currentUser
        
        self.state = user != nil ? .authorized : .unauthorized
        
        if self.state == .authorized, let user = user {
            
            print("user.uid =", user.uid)
            print("user.email =", user.email)
            print("user.photoURL =", user.photoURL)
        }
    }
}
