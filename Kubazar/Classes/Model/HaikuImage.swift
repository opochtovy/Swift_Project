//
//  HaikuImage.swift
//  Kubazar
//
//  Created by Mobexs on 11/25/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuImage {
    
    public var fileId: String?
    public var fileName: String?
    public var mimeType: String?
    public var urlString: String?
    
    public func initWithDictionary(dict: Dictionary<String, Any>) -> HaikuImage {
        
        fileId = dict["fileId"] != nil ? dict["fileId"] as! String : ""
        fileName = dict["fileName"] != nil ? dict["fileName"] as! String : ""
        mimeType = dict["mimeType"] != nil ? dict["mimeType"] as! String : ""
        urlString = dict["url"] != nil ? dict["url"] as! String : ""
        
//        print("HaikuImage : urlString =", urlString ?? "no image")
        
        return self
    }
}
