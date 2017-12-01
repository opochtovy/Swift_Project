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
    public var creatorId: String?
    
    init(user: User, text: String, finished: Bool = true) {
        self.owner = user
        self.text = text
        self.isFinished = finished
    }
    
    required convenience init?(map: Map){
        
        self.init(user: User(), text: "", finished: false)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        text <- map["line"]
        creatorId <- map["authorId"]
        owner <- map["creator"]
    }
}
