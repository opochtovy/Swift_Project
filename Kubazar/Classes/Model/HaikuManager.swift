//
//  HaikuManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/14/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuManager {

    public static let shared: HaikuManager = HaikuManager()
    public var currentUser: User = User()
    private(set) var haikus: [Haiku] = []
    public var friends: [User] = []
    
    //MARK: - Public functions
    
    public func like(toLike: Bool,haiku: Haiku) {
        
        haiku.liked = toLike
        
        if toLike == true {
            
            haiku.likesCount += 1
            
        } else if haiku.likesCount > 0 {
            
            haiku.likesCount -= 1
        }
    }
    
    public func publish(toPublish: Bool, haiku: Haiku) {        

        guard haiku.fields.count == 3 else { return }
        haiku.published = toPublish
        
        if toPublish == false {
            
            haiku.likesCount = 0
            haiku.liked = false
        }
    }
    
    public func delete(haiku: Haiku, user: User) {
        
        for field in haiku.fields {
            
            if field.owner == user {
                
                field.isActive = false
            }
        }
    }
   
    public func createNewHaiku(_ players: [User] = []) -> Haiku{
        
        let haiku = Haiku()
        haiku.creator = self.currentUser
        haiku.players = [self.currentUser]
 
        haiku.fields = [Field(user: haiku.players[0], text: ""),
                        Field(user: haiku.players[0], text: ""),
                        Field(user: haiku.players[0], text: "")]
        
        return haiku
    }
}
