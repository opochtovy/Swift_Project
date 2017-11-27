//
//  URLRequestConvertible+Extensions.swift
//  Kubazar
//
//  Created by Mobexs on 11/25/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

extension URLRequest {
    
    static func appendAuthHeader( request: inout URLRequest) -> URLRequest {
        
//        if let authToken = Authenticator.keychain[StoreKeys.authToken] {
//            
//            request.addValue(authToken, forHTTPHeaderField: "Token")
//        }
        return request
    }
}
