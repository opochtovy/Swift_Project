//
//  HaikuRouter.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

enum HaikuRouter: URLRequestConvertible {
    
    case likeHaiku(haikuId: String)

    var method: HTTPMethod {
        
        switch self {
        case .likeHaiku: return .put
        }
    }
    
    var path: String {
        
        switch self {
        case .likeHaiku(let haikuId): return "/haiku/like/\(haikuId)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        
        switch self {
        case .likeHaiku(_): print()
        }
        
        return urlRequest
    }
}
