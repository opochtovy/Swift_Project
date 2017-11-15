//
//  User.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

class User {
    
    public var id : Int = 0
    public var firstName: String = ""
    public var lastName: String = ""
    public var avatarURL: String?
    
    public lazy var fullName: String = {
        return "\(firstName) \(lastName)"
    }()
}

extension User: Equatable {
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

extension User: Hashable {
    
    var hashValue: Int {
        return self.id
    }
}
