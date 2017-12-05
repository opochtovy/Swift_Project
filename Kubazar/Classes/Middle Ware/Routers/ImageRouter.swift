//
//  ImageRouter.swift
//  Kubazar
//
//  Created by Mobexs on 11/30/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Alamofire

enum imageRouter: URLRequestConvertible {
    
    case addImage(argument: String , contentType: String, multipartFormData: Data)
    
    var method: HTTPMethod {
        
        switch self {
        case .addImage: return .put
        }
    }
    
    var path: String {
        
        switch self {
        case .addImage(let haikuId, _, _): return "haiku/image/\(haikuId)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        
        switch self {
        case .addImage(_, let contentType, let multipartData):
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = multipartData            
        }
        
        return urlRequest
    }
}
