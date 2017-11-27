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
    case getUserInfo(creatorId: String) // that router is to get user info by creatorId different from currentUser
    
    // Get Haiku
    case getPersonalHaikus()
    
    var method: HTTPMethod {
        
        switch self {
        case .addDeviceToken: return .put
        case .uploadUserAvatar: return .put
        case .downloadProfileImage: return .get
        case .getPersonalHaikus: return .get
        case .getUserInfo: return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .addDeviceToken(_): return "/user/device"
        case .uploadUserAvatar(_): return "/user/avatar"
        case .downloadProfileImage(_): return ""
        case .getPersonalHaikus(): return "/haiku/"
        case .getUserInfo(let creatorId): return "/user/info"
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
            
            
        case .getPersonalHaikus(): print()
            
        case .getUserInfo(_): print()
        }
        
        return urlRequest
    }

}
