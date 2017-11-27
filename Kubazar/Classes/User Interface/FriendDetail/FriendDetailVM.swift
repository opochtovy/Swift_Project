//
//  FriendDetailVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class FriendDetailVM: BaseVM {
    
    private(set) var userName = ""
    private(set) var userAvatarURL: URL?
    
    init(client: Client, user: User) {
        
        self.userName = "\(user.lastName) + \(user.firstName)"
        self.userAvatarURL = URL(string: user.avatarURL ?? "")
        super.init(client: client)
    }
}
