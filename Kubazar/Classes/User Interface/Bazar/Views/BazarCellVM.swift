//
//  BazarCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarCellVM {
    
    private(set) var creatorName: String = ""
    private(set) var participants: String = ""
    private(set) var dateInfo: String = ""
    private(set) var authorPictureURL: URL?
    
    private(set) var btnText: String = ""
    private(set) var isSingle: Bool = false
    private(set) var isLiked: Bool = false

    private(set) var textColor: HaikuColorStyle = .white
    
    private let haiku: Haiku
    
    init(haiku: Haiku) {
        
        self.haiku = haiku
        guard let creator = haiku.creator else { return }
        
        creatorName = creator.fullName
        
        var haikuParticipants: Set<User> = Set(haiku.participants)
        haikuParticipants.remove(creator)        
        
        let friendNames = haikuParticipants.flatMap({$0.fullName}).joined(separator: ", ")
        
        isSingle = haikuParticipants.count == 0
        
        let andString = self.isSingle ? "" : NSLocalizedString("Bazar_and", comment: "")
        participants = "\(andString) \(friendNames)"
        
        //TODO: udpate dates info with ago cases
        dateInfo = "23 min ago".uppercased()
        
        authorPictureURL = URL(string: creator.avatarURL ?? "")
        
        isLiked = haiku.liked
        btnText = "\(haiku.likesCount) \(NSLocalizedString("Bazar_likes", comment: ""))"
    }
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }

}
