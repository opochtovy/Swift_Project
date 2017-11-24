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
    
    static let BaseURL = Bundle.getBaseURL()
    let authenticator: FirebaseServerClient
    let reachabilityManager: NetworkReachabilityManager?
    
    init() {
        
        self.authenticator = FirebaseServerClient()
        self.reachabilityManager = NetworkReachabilityManager()
        
        if let reachabilityManager = self.reachabilityManager {
            
            reachabilityManager.startListening()
        }
    }
}
