//
//  FriendsVM.swift
//  
//
//  Created by Mobexs on 11/15/17.
//

import Foundation

class FriendsVM: BaseVM {

    public var maxFriends = 1
    private(set) var title = ""
    private let haiku : Haiku
    private var friends: [User] = []
    
    init(client: Client, maxFriends: Int) {
        self.maxFriends = maxFriends
        self.haiku = Haiku()
        self.haiku.creator = HaikuManager.shared.currentUser
        self.haiku.players = [HaikuManager.shared.currentUser]
        
        super.init(client: client)
        
        self.prepareModel()
    }
    
    //MARK: Public functions
    public func getFriends(completion: BaseCompletion) {
        
        let user1 = User()
        user1.id = 1
        user1.firstName = "Serge"
        user1.lastName = "Rylko"
        user1.avatarURL = "https://vignette.wikia.nocookie.net/animal-jam-clans-1/images/0/0d/Shiba-inu-puppy-2.jpg"
        
        let user2 = User()
        user2.id = 2
        user2.firstName = "Jimm"
        user2.lastName = "Smith"
        user2.avatarURL = "https://static.blog.playstation.com/wp-content/uploads/avatars/avatar_452240.jpg"
        
        let user3 = User()
        user3.id = 3
        user3.firstName = "Andy"
        user3.lastName = "Wood"
        user3.avatarURL = "https://pp.userapi.com/c9790/u125899584/a_47452a9d.jpg"
        
        let user4 = User()
        user4.id = 4
        user4.firstName = "Stan"
        user4.lastName = "Owlman"
        user4.avatarURL = "https://cdn.pixabay.com/photo/2017/03/06/15/44/bird-2121811_960_720.jpg"
        
        self.friends = [user1, user2, user3, user4]
        
        completion(true, nil)
    }
    
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
    
    //MARK: Private functions
    private func prepareModel() {
        
        if self.maxFriends == 1 {
            
            self.title = NSLocalizedString("Friends_choose_one", comment: "")
        }
        else if maxFriends > 1 {
            
            self.title = NSLocalizedString("Friends_choose", comment: "")
        }
    }
}
