//
//  HaikuManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/14/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuManager {
    
    enum HaikusFilter: Int {
        
        case all = 0
        case mine = 1
        case active = 2
    }

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
   
    public func createNewHaiku() -> Haiku{
        
        let haiku = Haiku()
        haiku.creator = self.currentUser
        haiku.players = [self.currentUser]
        haiku.id = "25" //
        
        return haiku
    }
    
    public func addNewHaikus(newHaikus: [Haiku], haikusType: Int, owners: [User]) -> [Haiku] {
        
        for haiku in newHaikus {
            
            for owner in owners {
                if owner.id == haiku.creator?.id {
                    
                    haiku.creator = owner
                }
                if haiku.players.contains(owner) {
                    
                    haiku.players.append(owner)
                }
            }
        }
        
        return newHaikus
    }
}
