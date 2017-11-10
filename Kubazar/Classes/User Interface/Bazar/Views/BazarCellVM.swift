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
    private(set) var haikuPictureURL: URL?
    
    private(set) var btnText: String = ""
    private(set) var isSingle: Bool = false

    private(set) var field1: String?
    private(set) var field2: String?
    private(set) var field3: String?
    private(set) var textColor: HaikuTextColor = .white
    
    init(haiku: Haiku) {
        
        guard let author = haiku.author else { return }
        
        authorName = author.fullName
        
        var friends: [User] = haiku.participants
        friends.remove(object: author)
        let friendNames = friends.flatMap({$0.fullName}).joined(separator: ", ")
        isSingle = friends.count == 0
        
        let andString = self.isSingle ? "" : NSLocalizedString("Bazar_and", comment: "")
        participants = "\(andString) \(friendNames)"
        
        //TODO: udpate dates info with ago cases
        dateInfo = "23 min ago".uppercased()
        
        self.field1 = haiku.fields[safe: 0]
        self.field2 = haiku.fields[safe: 1]
        self.field3 = haiku.fields[safe: 2]
        
        self.textColor = haiku.color
        
        authorPictureURL = URL(string: author.avatarURL ?? "")
        haikuPictureURL = URL(string: haiku.pictureURL ?? "")
        
        btnText = "\(haiku.likesCount) \(NSLocalizedString("Bazar_likes", comment: ""))"
    }

}
