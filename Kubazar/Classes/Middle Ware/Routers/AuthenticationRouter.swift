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
    
    case downloadProfileImage()
    
    var method: HTTPMethod {
        
        switch self {
        case .downloadProfileImage:    return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .downloadProfileImage:    return "https://firebasestorage.googleapis.com/v0/b/testkubazar.appspot.com/o/profileImages%2Fopochtovy_photo.jpg?alt=media&token=d529a107-e133-4220-a710-6bca734607a6" // test
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: URL(string: "https://firebasestorage.googleapis.com/")!)
        if let url = URL(string: self.path) {
            
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpShouldHandleCookies = false
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }

}
