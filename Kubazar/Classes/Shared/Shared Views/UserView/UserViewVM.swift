//
//  UserViewVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class UserViewVM {

    public let userImageURL: URL?
    public let firstName: String
    public let lastName: String
    
    init(withUser user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.userImageURL = user.avatarURL
    }
}
