//
//  HaikuPreviewVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class HaikuPreviewVM {
    
    private(set) var haikuPictureURL: URL?
    private(set) var field1: String?
    private(set) var field2: String?
    private(set) var field3: String?
    private(set) var textColor: HaikuTextColor = .white
    
    init(withHaiku haiku: Haiku) {
        
        self.field1 = haiku.fields[safe: 0]
        self.field2 = haiku.fields[safe: 1]
        self.field3 = haiku.fields[safe: 2]
        
        self.textColor = haiku.color
        
        self.haikuPictureURL = URL(string: haiku.pictureURL ?? "")
    }    
}
