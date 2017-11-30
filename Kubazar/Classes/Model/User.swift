//
//  User.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import FirebaseAuth
import ObjectMapper

protocol UserProtocol {
    
    var firstName: String { get set}
    var lastName: String { get set}
    var avatarURL: String? { get set}
    var avatarImageData: Data? { get set}
}

class User: MappableObject, UserProtocol {
    
    public var id : String = ""
    public var displayName: String?
    public var email: String?
    public var avatarURL: String?
    public var avatarImageData: Data? = nil
    
    public var firstName: String = ""
    public var lastName: String = ""
    public var phoneNumber: String = ""
    public var haikusCount: Int = 0
    public lazy var fullName: String = {
        return "\(firstName) \(lastName)"
    }()
    
    public func initWithFirebaseUser(firebaseUser: UserInfo) -> User {
        
        id = firebaseUser.uid
        displayName = firebaseUser.displayName
        email = firebaseUser.email
        avatarURL = firebaseUser.photoURL?.absoluteString
        
        let nameComponents = displayName?.components(separatedBy: " ")
        
        if let firstComponent = nameComponents?.first {
            
            firstName = firstComponent
        }
        if let components = nameComponents, components.count > 1, let lastComponent = nameComponents?.last {
            
            lastName = lastComponent
        }
        
        return self
    }
    
    required convenience init?(map: Map){
        
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["uid"]
        displayName <- map["displayName"]
        
        let nameComponents = displayName?.components(separatedBy: " ")
        firstName = nameComponents?[safe: 0] ?? ""
        lastName = nameComponents?[safe: 1] ?? ""
        
        avatarURL <- map["photoURL"]
        phoneNumber <- map["phoneNumber"]
        haikusCount <- map["haikusCount"]
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
