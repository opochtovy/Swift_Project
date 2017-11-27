//
//  Field.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class Field {

    public var id: Int = 0
    public var text: String?
    public var owner: User
    public var creatorId: String?
    
    /** false if user delete haiku from collection*/
    public var isActive: Bool = true
    
    /** defines user complete editing field*/
    public var isFinished: Bool = true
    
    init(user: User, text: String, finished: Bool = true) {
        self.owner = user
        self.text = text
    }
    
    public func initWithDictionary(dict: Dictionary<String, Any>) -> Field {
        
        text = dict["line"] != nil ? dict["line"] as! String : ""
        creatorId = dict["creatorId"] != nil ? dict["creatorId"] as! String : ""
        
//        print("Field : text =", text ?? "no text for Haiku")
        
        return self
    }
}
