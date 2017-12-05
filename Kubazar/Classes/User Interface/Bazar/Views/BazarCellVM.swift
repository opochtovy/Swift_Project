//
//  BazarCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarCellVM {
    
    enum ActionType {
        
        case like
        case publish
    }
    
    private(set) var creatorName: String = ""
    private(set) var participants: String = ""
    private(set) var dateInfo: String = ""
    private(set) var authorPictureURL: URL?
    
    private(set) var btnText: String = ""
    private(set) var isSingle: Bool = false
    private(set) var isLiked: Bool = false

    private(set) var actionType: ActionType = .like
    
    private var haiku: Haiku
    private var client: Client
    
    init(client: Client, haiku: Haiku) {
        
        self.client = client
        self.haiku = haiku
        self.prepareModel()
    }
    
    //MARK: - Public functions
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }
    
    public func performAction(completionHandler:@escaping (String?, Bool) -> ()) {
        
        if self.actionType == .like {
            
            self.client.authenticator.likeHaiku(haiku: haiku, completionHandler: { (errorDescription, success) in
                
                self.prepareLikes()
                completionHandler(nil, true)
            })
        }
        else if actionType == .publish {            
      
            HaikuManager.shared.publish(toPublish: true, haiku: self.haiku)
        }
    }
    
    public func isHaikuStatusCompleted() -> Bool {
        
        return self.haiku.isCompleted
    }
    
    //MARK: - Private functions
    
    private func prepareModel() {
        
        guard let creator = haiku.creator else { return }
        
        if let displayName = creator.displayName {
            
            creatorName = displayName
        }
        
        var haikuParticipants: Set<User> = Set(haiku.players)
        haikuParticipants.remove(creator)
        
        let friendNames = haikuParticipants.flatMap({$0.displayName}).joined(separator: ", ")
        
        isSingle = haikuParticipants.count == 0
        
        let andString = self.isSingle ? "" : NSLocalizedString("Bazar_and", comment: "")
        participants = "\(andString) \(friendNames)"
        
        //TODO: udpate dates info with ago cases
        dateInfo = self.haiku.finishDate.convertToDate().uppercased()
        
        authorPictureURL = URL(string: creator.avatarURL ?? "")
        
        self.actionType = haiku.isCompleted == true ? .like : .publish
        
        if haiku.isCompleted == true {
            
            self.prepareLikes()
        }
        else {
            
            btnText = NSLocalizedString("Bazar_publish", comment: "")
        }
    }
    
    private func prepareLikes() {
        
        let currentUserId = self.client.authenticator.getUserId()
        isLiked = self.haiku.likes.contains(currentUserId)
        
        if haiku.likesCount > 0 {
            
            btnText = "\(haiku.likesCount) \(NSLocalizedString("Bazar_likes", comment: ""))"
        }
        else {
            
            btnText = ""
        }
    }
    
    public func getThumbnailVM() -> UserThumbnailVM {
        
        if let creator = self.haiku.creator {
            
            return UserThumbnailVM(withUser: creator, needBorders: true)
        }
        return UserThumbnailVM(withUser: User(), needBorders: true)
    }

}
