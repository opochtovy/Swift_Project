//
//  WriteMainMenuVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class WriteMainMenuVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
    
    //MAKR: - public functions
    public func getFriendsVM(players: Int) -> FriendsVM {
        
        return FriendsVM(client: self.client, maxFriends: players)
    }
}
