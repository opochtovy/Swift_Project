//
//  BazarDetailVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarDetailVM: BaseVM {

    enum DetailBazarMode {
        
        case read
        case soloPrivate
        case soloPublic
        case partyAuthor
        case partyMember
    }
    
    private let haiku : Haiku
    public var mode : DetailBazarMode = .read
    
    public var dateText : String = ""
    public var isPublished : Bool = false
    public var isLiked: Bool = false
    public var likesCount: String = "0"
    
    private var userViewVMs : [UserViewVM] = []
    
    init(client: Client, haiku: Haiku) {
        
        self.haiku = haiku
        super.init(client: client)
        self.prepareModel()
    }
    
    //MARK: - Public functions
    public func getUserViewVM(forIndex index: Int) -> UserViewVM? {
        
        return self.userViewVMs[safe: index]
    }
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }
    
    public func like() {

        HaikuManager.shared.like(toLike: !self.haiku.liked, haiku: self.haiku)
        self.prepareModel()
    }
    
    public func publish() {
 
        HaikuManager.shared.publish(toPublish: !self.haiku.published, haiku: self.haiku)
        self.prepareModel()        
    }
    
    public func delete() {
        
        let user = User()
        user.id = "1"
        HaikuManager.shared.delete(haiku: self.haiku, user: user)
    }
    
    public func getHaikuImageURL() -> URL? {
        
        let imagePath = self.haiku.haikuImage?.urlString
        if let imagePath = imagePath {
            
            return URL(string: imagePath)
        }
        return URL(string: "")
    }
    
    //MARK: - Private functions
    private func prepareModel() {
    
        self.chooseMode()
        
        self.dateText = "23 Min Ago" //TODO: add date stamp
        self.isPublished = self.haiku.published
        self.isLiked = self.haiku.liked
        self.likesCount = "\(self.haiku.likesCount)"
        
        self.userViewVMs = []
        
        for user in Set(self.haiku.players) {
            self.userViewVMs.append(UserViewVM(withUser: user))
        }
    }
    
    private func chooseMode() {
        
        //mode choosing
        
        let isUserParticipant = self.haiku.players.contains { (user) -> Bool in
            user.id == HaikuManager.shared.currentUser.id
        }
        
        let isUserAuthor = self.haiku.creator?.id == HaikuManager.shared.currentUser.id
        
        let isUserSoloWritten = Set(self.haiku.players).count == 1 &&
                                self.haiku.players[0].id == HaikuManager.shared.currentUser.id
        
        if isUserSoloWritten {
            
            self.mode = self.haiku.published == true ? .soloPublic : .soloPrivate
            
        } else if isUserParticipant == false && haiku.published == true {
            
            self.mode = .read
            
        } else if isUserParticipant == true && isUserAuthor == true {
            
            self.mode = .partyAuthor
            
        } else if isUserParticipant == true && isUserAuthor == false {
            
            self.mode = .partyMember
            
        }  else {
            
            self.mode = .read
            print("Unexpected state")
        }
        
        print(self.mode)
    }
}
