//
//  BazarCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BazarCellVM {
    
    private(set) var authorName: String = ""
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
        guard let author = haiku.author else { return }
        
        authorName = author.fullName
        
        var friends: [User] = haiku.friends
        friends.remove(object: author)
        let friendNames = friends.flatMap({$0.fullName}).joined(separator: ", ")
        isSingle = friends.count == 0
        
        let andString = self.isSingle ? "" : NSLocalizedString("Bazar_and", comment: "")
        participants = "\(andString) \(friendNames)"
        
        //TODO: udpate dates info with ago cases
        dateInfo = "23 min ago".uppercased()
        
        authorPictureURL = URL(string: author.avatarURL ?? "")
        
        isLiked = haiku.liked
        btnText = "\(haiku.likesCount) \(NSLocalizedString("Bazar_likes", comment: ""))"
    }
    
    public func getPreviewVM() -> HaikuPreviewVM {
        
        return HaikuPreviewVM(withHaiku: self.haiku)
    }

}
