//
//  HaikuFont.swift
//  Kubazar
//
//  Created by Mobexs on 11/25/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuFont {

    public var family: String?
    public var size : Int = 11
    public var color: String?
    
    public func initWithDictionary(dict: Dictionary<String, Any>) -> HaikuFont {
        
        family = dict["family"] != nil ? dict["family"] as! String : ""
        size = dict["size"] != nil ? dict["size"] as! Int : 11
        color = dict["color"] != nil ? dict["color"] as! String : ""
        
//        print("HaikuFont : urlString =", family ?? "no family font for Haiku")
        
        return self
    }
}
