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
    
    //MARK: - Private functions
    
    private func allowToPassAuth() {
        
        self.loginAccepted = UserDefaults.standard.bool(forKey: "isUserAuthorized")
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChanged), name: NSNotification.Name(rawValue: FirebaseServerClient.AuthenticatorStateDidChangeNotification), object: nil)
    }
    
    //MARK: - Notification
    
    @objc private func userChanged() {
        
        self.loginAccepted = self.client.authenticator.state == .authorized
    }
}
