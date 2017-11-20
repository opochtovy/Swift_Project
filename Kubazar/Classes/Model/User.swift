//
//  User.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import FirebaseAuth

class User {
    
    public var id : String = ""
    public var displayName: String?
    public var email: String?
    public var avatarURL: URL?
    
    public var firstName: String = ""
    public var lastName: String = ""
    public lazy var fullName: String = {
        return "\(firstName) \(lastName)"
    }()
    
    public func initWithFirebaseUser(firebaseUser: UserInfo) -> User {
        
        id = firebaseUser.uid
        displayName = firebaseUser.displayName
        email = firebaseUser.email
        avatarURL = firebaseUser.photoURL
        
        return self
    }
}

extension User: Equatable {
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        
        return  lhs.id == rhs.id
    }
}

extension User: Hashable {
    
    var hashValue: Int {
        if let intValue = Int(self.id){
            
            return intValue
        }
        return 0
    }
}
