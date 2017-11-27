//
//  Haiku.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class Haiku {
    
    public var id : String = ""
    public var date: Date?
    public var pictureURL: String?
    public var creator: User?
    public var fields: [Field] = []
    public var published: Bool = false
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
    public var haikuFont: HaikuFont?
    
//    public func initWithDictionary(dict: Dictionary<String, Any>) -> Haiku {
//
//        return self
//    }

    
    public func initWithDictionary(dict: Dictionary<String, Any>) -> Haiku {
        
        id = dict["_id"] != nil ? dict["_id"] as! String : ""
        creatorId = dict["creatorId"] != nil ? dict["creatorId"] as! String : ""
        
        var theFields: [Field] = []
        let fieldDictsArray = dict["text"] != nil ? dict["text"] as! [Dictionary<String, Any>] : []
        for fieldDict in fieldDictsArray {
            
            var field = Field(user: User(), text: "", finished: false)
            field = field.initWithDictionary(dict: fieldDict)
            theFields.append(field)
        }
        fields = theFields
        
        published = dict["access"] as! String == "public"
//        isCompleted = dict["status"] as! String == "completed"
        playerIds = dict["owners"] != nil ? dict["owners"] as! [String] : []
        
        var thePlayers: [User] = []
        for playerId in playerIds {
            
            for owner in HaikuManager.shared.owners {
                
                if owner.id == playerId {
                    
                    thePlayers.append(owner)
                }
            }
        }
        players = thePlayers
        
        likes = dict["likes"] != nil ? dict["likes"] as! [String] : []
        likesCount = dict["likesCount"] != nil ? dict["likesCount"] as! Int : 0
        createDate = dict["createdOn"] != nil ? dict["createdOn"] as! Int : 0
        finishDate = dict["finishedOn"] != nil ? dict["finishedOn"] as! String : ""
        
        let image = HaikuImage()
        let haikuImageDict = dict["img"] as! Dictionary<String, Any>
        haikuImage = image.initWithDictionary(dict: haikuImageDict)
        
        let font = HaikuFont()
        let haikuFontDict = dict["font"] as! Dictionary<String, Any>
        haikuFont = font.initWithDictionary(dict: haikuFontDict)
        
//        print("creatorId =", creatorId ?? "no creator id")
        
        return self
    }

}

extension Haiku {
    
    public var activePlayers: [User] {

        return self.fields.filter({$0.isActive}).flatMap({$0.owner})
    }
    
    public var isCompleted: Bool {
        
        return self.finishedFieldsCount == 3
    }
    
    public var finishedFieldsCount: Int {
    
        return self.fields.flatMap({$0.isFinished}).count
    }
}

extension Haiku: Equatable {
    
    public static func ==(lhs: Haiku, rhs: Haiku) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

