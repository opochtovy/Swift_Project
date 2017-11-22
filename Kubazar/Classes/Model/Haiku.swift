//
//  Haiku.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class Haiku {
    
    public var id : Int = 0
    public var date: Date?
    public var pictureURL: String?
    public var likesCount: Int = 0
    public var creator: User?
    public var fields: [Field] = []    
    public var published: Bool = false
    public var liked: Bool = false
    public var players : [User] = []
    public var decorator: Decorator = Decorator()
}

extension Haiku {
    
    public var activePlayers: [User] {

        return self.fields.filter({$0.isActive}).flatMap({$0.owner})
    }
    
    public var isCompleted: Bool {
        
        return self.fields.count == 3
    }
}

extension Haiku: Equatable {
    
    public static func ==(lhs: Haiku, rhs: Haiku) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

