//
//  Haiku.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class Haiku: MappableObject {
    
    public var id : String = ""
    public var date: Date?
    public var pictureURL: String?
    public var creator: User?
    public var fields: [Field] = []
    public var published: Bool = false
    public var isCompleted: Bool = true
    public var likesCount: Int = 0
    public var liked: Bool = false
    public var players : [User] = []
    public var decorator: Decorator = Decorator()
    
    public var likes : [String] = []
    public var finishDate: String = ""
    public var createDate: String = ""
    public var access : String = ""
    public var status : String = ""
    
    required convenience init?(map: Map){
        
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["_id"]
        creator <- map["creator"]
        access <- map["access"]
        published = access == "public"
        
        status <- map["status"]
        isCompleted = status == "completed"
        
        likes <- map["likes"]
        likesCount <- map["likesCount"]
        finishDate <- map["finishedOn"]
        createDate <- map["createdOn"]
        
        pictureURL <- map["img.url"]
        decorator <- map["font"]
        
        fields <- (map["text"])
        players <- (map["owners"])
    }
}

extension Haiku {
    
    public var friends: [User] {
        
        return self.players.filter{$0 != self.creator}
    }
        
    public var currentTurnUser: User? {
        
        return self.fields.filter({$0.text == nil}).first?.owner
    }
}

extension Haiku: Equatable {
    
    public static func ==(lhs: Haiku, rhs: Haiku) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

