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
    }
    
    //MARK: - Private functions
    
    private func allowToPassAuth() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(userChanged), name: NSNotification.Name(rawValue: Authenticator.AuthenticatorStateDidChangeNotification), object: nil)
//        self.loginAccepted = self.client.authenticator.user != nil
    }
}
