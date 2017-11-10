//
//  Client.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

class Client {
    
    let sessionManager: SessionManager
    let authenticator: FirebaseServerClient
    
    init() {
        
        self.sessionManager = SessionManager()
        self.authenticator = FirebaseServerClient()
    }
}
