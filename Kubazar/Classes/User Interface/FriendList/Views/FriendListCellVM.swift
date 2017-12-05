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
    
    private var user: UserProtocol
    
    init(withUser user: UserProtocol, haikuCount: Int = 0,showInvite: Bool = false) {
        self.user = user
        self.showInviteButton = showInvite
        
        self.userName = "\(user.firstName) \(user.lastName)"
        self.haikuCounter = "\(haikuCount) \(NSLocalizedString("FriendList_haikus", comment: ""))"
        
        self.userURL = URL(string: user.avatarURL ?? "") 
    }
    
    public func getThumbnailVM() -> UserThumbnailVM {
        
        return UserThumbnailVM(withUser: self.user)
    }
    
    public func getUserNameForInvite() -> String {
        
        return self.user.firstName
    }
    
    public func getUserPhoneNumbers() -> [String] {
        
        guard let user = self.user as? ContactUser else { return [] }
        return user.phones
    }
}
