//
//  FriendsRouter.swift
//  Kubazar
//
//  Created by Mobexs on 11/29/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

enum FriendsRouter: URLRequestConvertible {
    
    case getFriends(bodyParameters: Parameters)
    case inviteFriend(bodyParameters: Parameters)
    
    var method: HTTPMethod {
        
        switch self {
        case .getFriends: return .post
        case .inviteFriend: return .post

        }
    }
    
    var path: String {
        
        switch self {
        case .getFriends: return "/user/friends"
        case .inviteFriend: return "/user/invite"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getFriends(let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        case .inviteFriend(let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        }
        
        return urlRequest
    }
}
