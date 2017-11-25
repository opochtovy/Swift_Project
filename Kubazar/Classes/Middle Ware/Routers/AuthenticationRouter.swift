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
    
    case addDeviceToken(bodyParameters: [String: String])
    case uploadUserAvatar(contentType: String, multipartFormData: Data)
    case downloadProfileImage(url: URL)
    
    var method: HTTPMethod {
        
        switch self {
        case .addDeviceToken: return .put
        case .uploadUserAvatar: return .put
        case .downloadProfileImage: return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .addDeviceToken(_): return "/v1/user/device"
        case .uploadUserAvatar(_): return "/user/avatar"
        case .downloadProfileImage(_): return ""
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        
        switch self {
            
        case .addDeviceToken(let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        case .uploadUserAvatar(let contentType, let multipartFormData):
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = multipartFormData
            
        case .downloadProfileImage(let url):
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpShouldHandleCookies = false
            urlRequest.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }

}
