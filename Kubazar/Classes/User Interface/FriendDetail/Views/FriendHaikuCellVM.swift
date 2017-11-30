//
//  FriendHaikuCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//
import Foundation

class FriendHaikuCellVM {
    
    public var haikuImageURL: URL?
    
    init(withHaiku haiku: Haiku) {
        
        self.haikuImageURL = URL(string: haiku.pictureURL ?? "")        
    }
}
