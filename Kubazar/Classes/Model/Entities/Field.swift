//
//  Field.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class Field: MappableObject {

    public var id: Int = 0
    public var text: String?
    public var owner: User
    
    init(user: User, text: String?) {
        self.owner = user
        self.text = text
    }
    
    required convenience init?(map: Map){
        
        self.init(user: User(), text: nil)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        text <- map["line"]
        owner <- map["creator"]
    }
}
