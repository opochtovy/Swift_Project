//
//  HaikuImage.swift
//  Kubazar
//
//  Created by Mobexs on 11/25/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class HaikuImage: MappableObject {
    
    public var fileId: String?
    public var fileName: String?
    public var mimeType: String?
    public var urlString: String?
    
    required convenience init?(map: Map){
        
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        fileId <- map["fileId"]
        fileName <- map["fileName"]
        mimeType <- map["mimeType"]
        urlString <- map["url"]
    }
}
