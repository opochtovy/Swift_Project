//
//  ContactUser.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Contacts

class ContactUser: UserProtocol {
    
    public var identifier : String = ""
    public var firstName : String = ""
    public var lastName : String = ""
    
    public var phones : [String] = []
    public var avatarImageData: Data?
    public var avatarURL: String?
    
    init(withContact contact: CNContact) {
        
        identifier = contact.identifier        
        firstName = contact.givenName
        lastName = contact.familyName
        phones = contact.phoneNumbers.flatMap{$0.value.stringValue}
        avatarImageData = contact.imageData
    }
}
