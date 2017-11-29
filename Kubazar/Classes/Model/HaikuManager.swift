//
//  HaikuManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/14/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuManager {
    
    enum HaikusFilter: Int {
        
        case all = 0
        case mine = 1
        case active = 2
    }

    public static let shared: HaikuManager = HaikuManager()
    public var currentUser: User = User()
//    private var filter: HaikusFilter = .all
    private(set) var haikus: [Haiku] = []
//    private(set) var personalHaikus: [Haiku] = []
    private(set) var owners: [User] = []
    private(set) var ownerIds: [String] = []
    private(set) var newOwnerIds: [String] = []
    
    init() {
        
        //--Mock
        let user = User()
        user.id = "1"
        user.firstName = "Serge"
        user.lastName = "Rylko"
        user.avatarURL = "https://vignette.wikia.nocookie.net/animal-jam-clans-1/images/0/0d/Shiba-inu-puppy-2.jpg"
//        self.currentUser = user
        
//        self.prepareData()
    }
    
    //MARK: - Public functions
    
    public func like(toLike: Bool,haiku: Haiku) {
        
        haiku.liked = toLike
        
        if toLike == true {
            
            haiku.likesCount += 1
            
        } else if haiku.likesCount > 0 {
            
            haiku.likesCount -= 1
        }
    }
    
    public func publish(toPublish: Bool, haiku: Haiku) {        

        guard haiku.fields.count == 3 else { return }
        haiku.published = toPublish
        
        if toPublish == false {
            
            haiku.likesCount = 0
            haiku.liked = false
        }
    }
    
    public func delete(haiku: Haiku, user: User) {
        
        for field in haiku.fields {
            
            if field.owner == user {
                
                field.isActive = false
            }
        }
    }
   
    public func createNewHaiku() -> Haiku{
        
        let haiku = Haiku()
        haiku.creator = self.currentUser
        haiku.players = [self.currentUser]
        haiku.id = "25" //
        
        return haiku
    }
    
    public func addNewHaikus(newHaikus: [Haiku], haikusType: Int, owners: [User]) -> [Haiku] {
        
        for haiku in newHaikus {
            
            for owner in owners {
                if owner.id == haiku.creatorId {
                    
                    haiku.creator = owner
                }
                if haiku.playerIds.contains(owner.id) {
                    
                    haiku.players.append(owner)
                }
            }
        }
        
        guard let aFilter = HaikuManager.HaikusFilter(rawValue: haikusType) else {
            
            return []
        }
        
        switch aFilter {
        case .all:
//            self.haikus = newHaikus // incorrect adding of new haikus to existing array of haikus
            print("HaikuManager : self.haikus count =", self.haikus.count)
        default:
            print()
        }
        
        self.findOutNewOwnerIds()
        
        return newHaikus
    }
    
    //MARK: - Private functions
    
    private func findOutNewOwnerIds() {
        
        var newOwnerIdsArray: [String] = []
        
        for haiku in self.haikus {
            
            for ownerId in haiku.playerIds {
                
                if !self.ownerIds.contains(ownerId) {
                    
                    newOwnerIdsArray.append(ownerId)
                }
            }
        }
        
        self.newOwnerIds = newOwnerIdsArray
    }
    
    private func prepareData() {
        //MOCKED data
        //-- users
        let user1 = User()
        user1.id = "1"
        user1.firstName = "Serge"
        user1.lastName = "Rylko"
        user1.avatarURL = "https://vignette.wikia.nocookie.net/animal-jam-clans-1/images/0/0d/Shiba-inu-puppy-2.jpg"
        
        let user2 = User()
        user2.id = "2"
        user2.firstName = "Jimm"
        user2.lastName = "Smith"
        user2.avatarURL = "https://static.blog.playstation.com/wp-content/uploads/avatars/avatar_452240.jpg"
        
        let user3 = User()
        user3.id = "3"
        user3.firstName = "Andy"
        user3.lastName = "Wood"
        user3.avatarURL = nil//"https://pp.userapi.com/c9790/u125899584/a_47452a9d.jpg"
        
        let user4 = User()
        user4.id = "4"
        user4.firstName = "Stan"
        user4.lastName = "Owlman"
        user4.avatarURL = "https://cdn.pixabay.com/photo/2017/03/06/15/44/bird-2121811_960_720.jpg"
        
        let field1 = Field(user: user1, text: "I am first with five")
        let field2 = Field(user: user2, text: "Then seven in the middle --")
        let field3 = Field(user: user3, text: "Five again to end.")
        
        let field4 = Field(user: user4, text: "Nothing happens")
        let field5 = Field(user: user1, text: "Solo1 happens")
        let field6 = Field(user: user3, text: "Solo2 happens")
        
        let field7 = Field(user: user2, text: "Nothing happens")
        let field8 = Field(user: user3, text: "Solo1 happens")
//        let field9 = Field(user: user1, text: "Solo2 happens")
        
        let field10 = Field(user: user4, text: "Nothing happens")
        let field11 = Field(user: user1, text: "Solo1 happens")
        let field12 = Field(user: user2, text: "Solo2 happens")
        
        let field13 = Field(user: user4, text: "Nothing happens")
        let field14 = Field(user: user1, text: "Solo1 happens", finished: false)
//        let field15 = Field(user: user1, text: "Solo2 happens")
        
        let field16 = Field(user: user4, text: "Nothing happens")
        let field17 = Field(user: user3, text: "Solo1 happens")
        let field18 = Field(user: user2, text: "Solo2 happens")
        
        let field19 = Field(user: user4, text: "Nothing happens")
        let field20 = Field(user: user1, text: "Solo1 happens")
        let field21 = Field(user: user2, text: "Solo2 happens")
        
        let field22 = Field(user: user1, text: "Nothing happens")
        let field23 = Field(user: user1, text: "Solo1 happens test")
        let field24 = Field(user: user1, text: "Solo2 happens at 11")
        
        let field25 = Field(user: user1, text: "2 players haiku")
        let field26 = Field(user: user2, text: "Next string")
        
        ////-- haikus
        let h1 = Haiku()
        h1.id = "2"
        h1.creator = user2
        h1.likesCount = 10
        h1.fields = [field1, field2, field3]
        h1.pictureURL = "https://www.nature.org/cs/groups/webcontent/@photopublic/documents/media/nags-head-canoe-537x448.jpg"
        h1.decorator.fontHexColor = "ffffff"
        h1.published = false
        h1.liked = true
        h1.players = [h1.creator!, user2, user3]
        
        let h2 = Haiku()
        h2.id = "6"
        h2.creator = user3
        h2.likesCount = 10
        h2.fields = [field4, field5, field6]
        h2.pictureURL = "https://www.nature.org/cs/groups/webcontent/@web/@montana/documents/media/mt-freshwater-homepage-thumb.jpg"
        h2.decorator.fontHexColor = "000000"
        h2.published = true
        h2.liked = true
        h2.players = [user3, user4, user1]
        
        let h3 = Haiku()
        h3.id = "3"
        h3.creator = user2
        h3.likesCount = 366
        h3.fields = [field7, field8]
        h3.pictureURL = "https://upload.wikimedia.org/wikipedia/commons/a/a5/LightningVolt_Deep_Blue_Sea.jpg"
        h3.decorator.fontHexColor = "ffffff"
        h3.published = false
        h3.liked = false
        h3.players = [user2, user3, user1]
        
        let h4 = Haiku()
        h4.id = "4"
        h4.creator = user1
        h4.likesCount = 0
        h4.fields = [field10, field11, field12]
        h4.pictureURL = "https://pbs.twimg.com/media/DOELEPpUQAAhGfq.jpg"
        h4.decorator.fontHexColor = "ffffff"
        h4.published = true
        h4.liked = false
        h4.players = [user4, h4.creator!, user2]
        
        let h5 = Haiku()
        h5.id = "5"
        h5.creator = user1
        h5.likesCount = 12
        h5.fields = [field13, field14]
        h5.pictureURL = "https://i.pinimg.com/736x/b9/35/e2/b935e2f758a9add5374bfb9196922630--aspen-trees-nature-trees.jpg"
        h5.decorator.fontHexColor = "000000"
        h5.published = false
        h5.liked = true
        h5.players = [user4, h5.creator!]
        
        let h6 = Haiku()
        h6.id = "6"
        h6.creator = user3
        h6.likesCount = 5
        h6.fields = [field16, field17, field18]
        h6.pictureURL = "https://i.pinimg.com/736x/0d/82/81/0d82811565290a4711119ea19b3df8db--green-nature-into-the-woods.jpg"
        h6.decorator.fontHexColor = "ffffff"
        h6.published = true
        h6.liked = true
        h6.players = [user4, h6.creator!, user2]
        
        let h7 = Haiku()
        h7.id = "7"
        h7.creator = user4
        h7.likesCount = 1500
        h7.fields = [field19, field20, field21]
        h7.pictureURL = "https://upload.wikimedia.org/wikipedia/commons/4/42/Ruins_in_jungles.JPG"
        h7.decorator.fontHexColor = "ffffff"
        h7.published = true
        h7.liked = false
        h7.players = [h7.creator!, user1, user2]
        
        let h8 = Haiku()
        h8.id = "8"
        h8.creator = user1
        h8.likesCount = 1500
        h8.fields = [field22, field23, field24]
        h8.pictureURL = "https://i.pinimg.com/736x/e5/b9/73/e5b97314faf43866131f3c86b85733fd--wallpaper-desktop-jungle.jpg"
        h8.decorator.fontHexColor = "ffffff"
        h8.published = false
        h8.liked = true
        h8.players = [h8.creator!]
        
        let h9 = Haiku()
        h9.id = "8"
        h9.creator = user1
        h9.likesCount = 777
        h9.fields = [field25, field26]
        h9.pictureURL = "https://i.pinimg.com/736x/e5/b9/73/e5b97314faf43866131f3c86b85733fd--wallpaper-desktop-jungle.jpg"
        h9.decorator.fontHexColor = "ffffff"
        h9.published = false
        h9.liked = true
        h9.players = [user1, user2]
        
        self.haikus = [h1, h2, h3, h4, h5, h6, h7, h8, h9]
    }
}
