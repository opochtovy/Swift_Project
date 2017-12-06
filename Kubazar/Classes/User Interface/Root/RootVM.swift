//
//  RootVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class RootVM: BaseVM {
    
    public var loginAccepted: Bool = false
    
    override init(client: Client) {
        
        super.init(client: client)
        self.allowToPassAuth()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Public functions
    
    public func signOut() {
        
        self.client.authenticator.signOut { (errorDescription, success) in
            
            self.loginAccepted = false
            UserDefaults.standard.set(false, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            self.client.authenticator.authToken = ""
            self.client.authenticator.sessionManager.adapter = SessionTokenAdapter(sessionToken: "")
            HaikuManager.shared.currentUser = User()
            
            if let authToken = self.client.authenticator.authToken, authToken.count > 0 {
                
                print("RooVM : authToken =", authToken)
                print("Error")
            }
        }
    }
    
    public func checkLoginState() {
        
        if self.loginAccepted {
            
            print("RootVM : authToken =", self.client.authenticator.authToken ?? "no authToken")
            print("StoreKeys.isUserAuthorized =", UserDefaults.standard.bool(forKey: StoreKeys.isUserAuthorized))
            UserDefaults.standard.set(true, forKey: StoreKeys.isUserAuthorized)
            UserDefaults.standard.synchronize()
            if let authToken = self.client.authenticator.authToken, authToken.count > 0 {
                
                self.client.authenticator.sessionManager.adapter = SessionTokenAdapter(sessionToken: authToken)
            }
            self.client.authenticator.activateCurrentUser()
        }
    }
    
    public func setStateOfCurrentUser() {
        
        self.client.authenticator.setStateOfCurrentUser()
    }
    
    //MARK: - Private functions
    
    private func allowToPassAuth() {
        
        self.loginAccepted = UserDefaults.standard.bool(forKey: StoreKeys.isUserAuthorized)
        
        if !self.loginAccepted {
            self.deleteAuthToken()
        }
        print("RootVM : self.loginAccepted =", self.loginAccepted)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChanged), name: NSNotification.Name(rawValue: FirebaseServerClient.AuthenticatorStateDidChangeNotification), object: nil)
    }
    
    private func deleteAuthToken() {
        
        self.client.authenticator.authToken = ""
        self.client.authenticator.sessionManager.adapter = SessionTokenAdapter(sessionToken: "")
    }
    
    //MARK: - Notification
    
    @objc private func userChanged() {
        
        self.loginAccepted = self.client.authenticator.state == .authorized
    }
}
