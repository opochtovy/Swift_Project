//
//  Notification.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class KBNotification: MappableObject {
    
    public enum NotificationType {
        
        case publish
        case like
        case share
        case remember
        case nextTurn
    }
    
    public var user: User
    public var haiku: Haiku
    public var type: NotificationType
    public var readed: Bool = false
    public var date: Date
    
    public var id : String = ""
    public var userId : String = ""
    public var haikuId : String = ""
    public var aType : String = ""
    public var text : String = ""
    public var createdOn : String = ""
    
    init(haiku: Haiku, user: User, date: Date, type: NotificationType) {
        self.haiku = haiku
        self.user = user
        self.date = date
        self.type = type
    }
    
    required convenience init?(map: Map){
        
        self.init(haiku: Haiku(), user: User(), date: Date(), type: .publish)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["_id"]
        userId <- map["userId"]
        haikuId <- map["haikuId"]
        aType <- map["type"]
        switch aType {
        case "nextTurn": type = .nextTurn
        case "like": type = .like
        default: print()
        }
        text <- map["text"]
        createdOn <- map["createdOn"]
        user <- map["user"]
        haiku <- map["haiku"]
    }
}
