//
//  AuthenticationRouter.swift
//  Kubazar
//
//  Created by Mobexs on 11/14/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

enum AuthenticationRouter: URLRequestConvertible {
    
    case login(authParameters: Parameters)
    
    var method: HTTPMethod {
        
        switch self {
        case .login:    return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .login:    return "/..."
        }
    }
    
    var url: URL {
        switch self {
        case .login: return URL(string: "")!
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: self.url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case .login(let parameters):
            
            urlRequest.addValue(parameters["Authorization"] as! String, forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpShouldHandleCookies = false
        
        return urlRequest
    }

}
