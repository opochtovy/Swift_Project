//
//  NotificationRouter.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 02.12.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

enum NotificationRouter: URLRequestConvertible {
    
    case getNotifications(urlParameters: Parameters)
    
    var method: HTTPMethod {
        
        switch self {
        case .getNotifications: return .get
            
        }
    }
    
    var path: String {
        
        switch self {
        case .getNotifications: return "/notification/"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getNotifications(let urlParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: urlParameters)
            
        }
        
        return urlRequest
    }
}
