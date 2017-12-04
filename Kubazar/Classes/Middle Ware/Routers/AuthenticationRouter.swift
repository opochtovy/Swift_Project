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
    
    case addFCMToken(bodyParameters: Parameters)
    case uploadUserAvatar(contentType: String, multipartFormData: Data)
    case downloadProfileImage(url: URL)
    case getUserInfo(creatorId: String) // that router is to get user info by creatorId different from currentUser
    
    var method: HTTPMethod {
        
        switch self {
        case .addFCMToken: return .put
        case .uploadUserAvatar: return .put
        case .downloadProfileImage: return .get
        case .getUserInfo: return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .addFCMToken(_): return "/user/device"
        case .uploadUserAvatar(_): return "/user/avatar"
        case .downloadProfileImage(_): return ""
        case .getUserInfo(let creatorId): return "/user/info"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
            
        case .addFCMToken(let bodyParameters):
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
            
        case .getUserInfo(_): print()
        }
        
        return urlRequest
    }

}
