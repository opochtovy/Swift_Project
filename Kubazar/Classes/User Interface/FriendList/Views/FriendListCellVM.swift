//
//  FriendListCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class FriendListCellVM {
    
    private(set) var userName: String = ""
    private(set) var haikuCounter: String = ""
    private(set) var userURL: URL?
    
    public let showInviteButton: Bool
    
    init(withUser user: User, haikuCount: Int = 0,showInvite: Bool = false) {
        self.showInviteButton = showInvite
        
        self.userName = user.fullName
        self.haikuCounter = "\(haikuCount) \(NSLocalizedString("FriendList_haikus", comment: ""))"
        
        self.userURL = URL(string: user.avatarURL ?? "") 
    }
}
