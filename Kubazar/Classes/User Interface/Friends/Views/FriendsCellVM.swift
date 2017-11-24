//
//  FriendsCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class FriendsCellVM {

    public var name: String = ""
    public var initials: String = ""
    public var iconUrl: URL?
    public var isChosen: Bool = false
    
    init(user: User, isChosen: Bool) {
        
        self.name = user.fullName
        self.iconUrl = URL(string: user.avatarURL ?? "")
        self.isChosen = isChosen
    }
}
