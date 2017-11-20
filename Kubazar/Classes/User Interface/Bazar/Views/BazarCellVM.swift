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

    private(set) var textColor: HaikuColorStyle = .white
    private(set) var actionType: ActionType = .like
    
    private let haiku: Haiku
    
    init(haiku: Haiku) {
        
        self.haiku = haiku
        self.prepareModel()
    }
    
    //MARK: - Public functions
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }
    
    public func performAction() {
        
        if self.actionType == .like {
            
            HaikuManager.shared.like(toLike: !self.haiku.liked, haiku: self.haiku)
            self.prepareLikes()
        }
        else if actionType == .publish {
            
            HaikuManager.shared.publish(toPublish: true, haiku: self.haiku)
        }
    }
    
    //MARK: - Private functions
    
    private func prepareModel() {
        
        guard let creator = haiku.creator else { return }
        
        creatorName = creator.fullName
        
        var haikuParticipants: Set<User> = Set(haiku.players)
        haikuParticipants.remove(creator)
        
        let friendNames = haikuParticipants.flatMap({$0.fullName}).joined(separator: ", ")
        
        isSingle = haikuParticipants.count == 0
        
        let andString = self.isSingle ? "" : NSLocalizedString("Bazar_and", comment: "")
        participants = "\(andString) \(friendNames)"
        
        //TODO: udpate dates info with ago cases
        dateInfo = "23 min ago".uppercased()
        
        authorPictureURL = creator.avatarURL
        
        self.actionType = haiku.isCompleted == true ? .like : .publish
        
        if haiku.isCompleted == true {
            
            self.prepareLikes()
        }
        else {
            
            btnText = NSLocalizedString("Bazar_publish", comment: "")
        }
    }
    
    private func prepareLikes() {
        
        isLiked = haiku.liked
        
        if haiku.likesCount > 0 {
            
            btnText = "\(haiku.likesCount) \(NSLocalizedString("Bazar_likes", comment: ""))"
        }
        else {
            
            btnText = ""
        }
    }

}
