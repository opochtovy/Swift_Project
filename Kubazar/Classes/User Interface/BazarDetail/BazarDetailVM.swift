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
    
    public func like(completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.client.authenticator.likeHaiku(haiku: haiku, completionHandler: { (errorDescription, success) in
            
            self.prepareModel()
            completionHandler(nil, true)
        })
    }
    
    public func publish(completionHandler:@escaping (String?, Bool) -> ())  {
        
        self.client.authenticator.changeHaikuAccess(haiku: haiku, completionHandler: { (errorDescription, success) in
            
            self.prepareModel()
            completionHandler(nil, true)
        })
    }
    
    public func delete(completionHandler:@escaping (String?, Bool) -> ()) {
        
        self.client.authenticator.deleteHaiku(haikuId: haiku.id, completionHandler: { (errorDescription, success) in
            
            completionHandler(nil, true)
        })
    }
    
    public func getHaikuToDelete() -> Haiku {
        
        return self.haiku
    }
    
    //MARK: - Private functions
    private func prepareModel() {
    
        self.chooseMode()
        
        self.dateText = self.haiku.finishDate.convertToDate()
        self.isPublished = self.haiku.published
        let currentUserId = self.client.authenticator.getUserId()
        isLiked = self.haiku.likes.contains(currentUserId)
        self.likesCount = haiku.likesCount > 0 ? "\(self.haiku.likesCount)" : ""
        
        self.userViewVMs = []
        
        for user in Set(self.haiku.players) {
            self.userViewVMs.append(UserViewVM(withUser: user))
        }
    }
    
    private func chooseMode() {
        
        //mode choosing
        
        let authorIds = haiku.fields.flatMap{$0.creatorId}
        
        print("authorIds =", authorIds)
        print("HaikuManager.shared.currentUser.id =", HaikuManager.shared.currentUser.id)
        for owner in self.haiku.players {
            print("player id =", owner.id)
        }
        print("self.haiku.players.count =", self.haiku.players.count)
        
        let isUserParticipant = authorIds.contains(HaikuManager.shared.currentUser.id)
        
        let isUserAuthor = self.haiku.creator?.id == HaikuManager.shared.currentUser.id
        
        let isUserSoloWritten = self.haiku.players.count == 1 &&
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
