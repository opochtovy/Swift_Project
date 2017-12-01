//
//  FriendsVM.swift
//  
//
//  Created by Mobexs on 11/15/17.
//

import Foundation

class FriendsVM: FriendsBaseVM {

    public let maxFriends: Int
    private(set) var title = ""
    private let haiku : Haiku
    private var friends: [User] = []
    
    init(client: Client, maxFriends: Int, haiku: Haiku) {
        
        self.maxFriends = maxFriends
        self.haiku = haiku
        super.init(client: client)
        
        self.prepareModel()
    }
    
    //MARK: Public functions
    
    public func numberOfItems() -> Int {
        
        return friends.count
    }
    
    public func getFriendsCellVM(forIndexPath indexPath: IndexPath) -> FriendsCellVM{
    
        let friend = self.friends[indexPath.row]
        let chosen = self.haiku.players.contains(friend)
        return FriendsCellVM(user: friend, isChosen: chosen)
    }
    
    public func chooseFriend(row: Int) {
        
        let friend = self.friends[row]
        
        if self.haiku.players.contains(friend) {
            
            self.haiku.players.remove(object: friend)
        }
        else if (self.haiku.players.count - 1) < self.maxFriends {
            
           self.haiku.players.append(friend)
        }
    }
    
    public func nextActionAllowed() -> Bool {
        
        return (self.haiku.players.count - 1) == maxFriends
    }
    
    public func getPictureVM() -> PictureVM {
        
        switch self.haiku.players.count {
            
        case 2:
            self.haiku.fields[1] = Field(user: self.haiku.players[1], text: "")
            self.haiku.fields[2] = Field(user: self.haiku.players[0], text: "")
        case 3:
            self.haiku.fields[1] = Field(user: self.haiku.players[1], text: "")
            self.haiku.fields[2] = Field(user: self.haiku.players[2], text: "")
        default:
            break
        }
        print("-- Players Count -- \(self.haiku.players.count)")
        print("-- Friends Count -- \(self.haiku.friends.count)")
        return PictureVM(client: self.client, haiku: self.haiku)
    }
    
    //MARK: Private functions
    override func prepareModel() {
        
        if self.maxFriends == 1 {
            
            self.title = NSLocalizedString("Friends_choose_one", comment: "")
        }
        else if maxFriends > 1 {
            
            self.title = NSLocalizedString("Friends_choose", comment: "")
        }
        
        self.friends = HaikuManager.shared.friends
    }
}
