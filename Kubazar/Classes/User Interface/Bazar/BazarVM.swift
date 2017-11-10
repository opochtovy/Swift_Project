//
//  BazarVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation


class BazarVM: BaseVM {
    
    enum BazarFilter: Int {
        
        case all = 0
        case mine = 1
        case active = 2
    }
    
    enum BazarSort: Int {
        
        case date = 0
        case likes = 1
    }
    
    public var filter: BazarFilter = .all
    public var sort: BazarSort = .date
    private var haikus: [Haiku] = []
    
    //MARK: -
    
    override init(client: Client) {
        super.init(client: client)
        self.prepareVMs()
    }
    
    //MARK: - Public functions
    public func numberOfItems() -> Int {
        
        return self.haikus.count
    }
    
    public func getCellVM(forIndexPath indexPath: IndexPath) -> BazarCellVM {
        
        return BazarCellVM(haiku: self.haikus[indexPath.row])
    }
    
    //MARK: - Private functions
    
    private func prepareVMs() {
        
        //TESTED dataSource. start
        
        //-- users
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
        
        ////-- haikus
        let h1 = Haiku()
        h1.id = 2
        h1.author = user2
        h1.participants = [user1, user2, user3]
        h1.likesCount = 10
        h1.fields = ["Sun shine", "Mind blows", "Samuray goes home"]
        h1.pictureURL = "https://www.nature.org/cs/groups/webcontent/@photopublic/documents/media/nags-head-canoe-537x448.jpg"
        h1.color = .white
        
        let h2 = Haiku()
        h2.id = 6
        h2.author = user3
        h2.participants = [user1, user2, user3]
        h2.likesCount = 10
        h2.fields = ["Cat eat", "Mouse cry", "Winter"]
        h2.pictureURL = "https://www.nature.org/cs/groups/webcontent/@web/@montana/documents/media/mt-freshwater-homepage-thumb.jpg"
        h2.color = .black
        
        let h3 = Haiku()
        h3.id = 3
        h3.author = user1
        h3.participants = [user1, user2]
        h3.likesCount = 366
        h3.fields = ["First", "second", "Thirt"]
        h3.pictureURL = "https://upload.wikimedia.org/wikipedia/commons/a/a5/LightningVolt_Deep_Blue_Sea.jpg"
        h3.color = .white
        
        let h4 = Haiku()
        h4.id = 4
        h4.author = user1
        h4.participants = [user1, user2, user3]
        h4.likesCount = 0
        h4.fields = ["Sun shine Sun shine Sun shineSun shineSun shine", "Mind blows Mind blows Mind blows Mind blows", "Samuray goes home"]
        h4.pictureURL = "https://pbs.twimg.com/media/DOELEPpUQAAhGfq.jpg"
        h2.color = .white
        
        let h5 = Haiku()
        h5.id = 5
        h5.author = user1
        h5.participants = [user1, user2, user3]
        h5.likesCount = 12
        h5.fields = ["Sun shine", "Mind blows", "Samuray goes home"]
        h5.pictureURL = "https://i.pinimg.com/736x/b9/35/e2/b935e2f758a9add5374bfb9196922630--aspen-trees-nature-trees.jpg"
        h5.color = .black
        
        let h6 = Haiku()
        h6.id = 6
        h6.author = user3
        h6.participants = [user3]
        h6.likesCount = 5
        h6.fields = ["Sun shine", "Mind blows", "Samuray goes home"]
        h6.pictureURL = "https://i.pinimg.com/736x/0d/82/81/0d82811565290a4711119ea19b3df8db--green-nature-into-the-woods.jpg"
        h6.color = .white
        
        self.haikus = [h1, h2, h3, h4, h5, h6]
        
        //TESTED end
    }
}
