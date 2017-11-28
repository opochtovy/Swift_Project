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
    
    public var creatorId: String?
    public var playerIds : [String] = []
    public var likes : [String] = []
    public var createDate: Int = 0
    public var finishDate: String = ""
    public var haikuImage: HaikuImage?
    public var haikuFont: Decorator?
    public var access : String = ""
    
    required convenience init?(map: Map){
        
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["_id"]
        creatorId <- map["creatorId"]
        access <- map["access"]
        published = access == "public"
        
        var status: String = ""
        status <- map["status"]
        isCompleted = status == "completed"
        
        likes <- map["likes"]
        likesCount <- map["likesCount"]
        createDate <- map["createdOn"]
        finishDate <- map["finishedOn"]
        
        haikuImage <- map["img"]
        haikuFont <- map["font"]
        
        fields <- (map["text"])
        playerIds <- (map["owners"])
        
        // ??? - needs to be changed when request to get user info will be ready and HaikuManager.shared.owners will be filled
        var thePlayers: [User] = []
        for playerId in playerIds {
            
            for owner in HaikuManager.shared.owners {
                
                if owner.id == playerId {
                    
                    thePlayers.append(owner)
                }
            }
        }
        players = thePlayers
    }

}

extension Haiku {
    
    public var activePlayers: [User] {

        return self.fields.filter({$0.isActive}).flatMap({$0.owner})
    }
    
//    public var isCompleted: Bool {
//
//        return self.finishedFieldsCount == 3
//    }
    
    public var finishedFieldsCount: Int {
    
        return self.fields.flatMap({$0.isFinished}).count
    }
}

extension Haiku: Equatable {
    
    public static func ==(lhs: Haiku, rhs: Haiku) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

