//
//  SessionTokenAdapter.swift
//  Kubazar
//
//  Created by Mobexs on 11/14/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

class SessionTokenAdapter: RequestAdapter {
    
    private let sessionToken: String
    
    init(sessionToken: String) {
        
        self.sessionToken = "Bearer " + sessionToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlRequest = urlRequest
        urlRequest.setValue(self.sessionToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpShouldHandleCookies = false
        
        return urlRequest
    }
}
