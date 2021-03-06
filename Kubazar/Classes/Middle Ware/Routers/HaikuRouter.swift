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
    
    case getAllHaikus(urlParameters: Parameters)
    case getPersonalHaikus(urlParameters: Parameters)
    case getActiveHaikus(urlParameters: Parameters)
    case likeHaiku(haikuId: String)
    case deleteHaiku(haikuId: String)
    case changeHaikuAccess(haikuId: String, bodyParameters: Parameters)
   
    case createSingleHaiku(bodyParameters: Parameters)
    case createMultiHaiku(bodyParameters: Parameters)
    case addLine(arguments: Parameters, bodyParameters: Parameters)

    var method: HTTPMethod {
        
        switch self {
        case .getAllHaikus: return .get
        case .getPersonalHaikus: return .get
        case .getActiveHaikus: return .get
        case .likeHaiku: return .put
        case .deleteHaiku: return .delete
        case .changeHaikuAccess: return .put
        
        case .createSingleHaiku: return .post
        case .createMultiHaiku: return .post
        case .addLine: return .put
        }
    }
    
    var path: String {
        
        switch self {
        case .getAllHaikus(_): return "/haiku/feed"
        case .getPersonalHaikus(_): return "/haiku/"
        case .getActiveHaikus(_): return "/haiku/active"
        case .likeHaiku(let haikuId): return "/haiku/like/\(haikuId)"
        case .deleteHaiku(let haikuId): return "/haiku/\(haikuId)"
        case .changeHaikuAccess(let haikuId, _): return "/haiku/access/\(haikuId)"
        case .createSingleHaiku(_): return "/haiku/single"
        case .createMultiHaiku(_): return "/haiku/plural"
        case .addLine(let arguments,_):
            guard let haikuId = arguments["haikuID"] else { return "" }
            return "/haiku/line/\(haikuId)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Client.BaseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getAllHaikus(let urlParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: urlParameters)
            
        case .getPersonalHaikus(let urlParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: urlParameters)
            
        case .getActiveHaikus(let urlParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: urlParameters)
            
        case .changeHaikuAccess(_, let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        case .createSingleHaiku(let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        case .createMultiHaiku(let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        case .addLine(_, let bodyParameters):
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
        default: print()
        }
        
        print("HaikuRouter : urlRequest.url =\(urlRequest.url)")
        
        return urlRequest
    }
}
