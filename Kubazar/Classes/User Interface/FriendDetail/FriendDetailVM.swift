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
    private(set) var phoneNumber = ""
    private(set) var userAvatarURL: URL?
    
    private var userHaikus: [Haiku] = []
    
    private let user: User
    init(client: Client, user: User) {
        
        self.user = user
        super.init(client: client)
        
        self.userName = "\(user.lastName) \(user.firstName)"
        self.phoneNumber = user.phoneNumber
        self.userAvatarURL = URL(string: user.avatarURL ?? "")
    }
    
    public func getUserData(completion: BaseCompletion) {
        
        //-- mocked userdata fetch
        self.userHaikus = HaikuManager.shared.haikus.filter { (haiku) -> Bool in
            
            return haiku.players.contains(self.user)
        }
        
        completion(true, nil)
    }
    
    public func numberIfItems() -> Int {
        
        return userHaikus.count
    }
    
    public func getFriendHaikuCellVM(forIndexPath indexPath: IndexPath) -> FriendHaikuCellVM {
        
        return FriendHaikuCellVM(withHaiku: self.userHaikus[indexPath.row])
    }
    
    public func getHaikuDetailVM(forIndexPath indexPath: IndexPath) -> BazarDetailVM {
        
        return BazarDetailVM(client: self.client, haiku: self.userHaikus[indexPath.row])
    }
}
