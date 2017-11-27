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
    
    private(set) var fontHexColor: String = Decorator.defaults.fontColor
    private(set) var fontSize: Float = Decorator.defaults.fontSize
    private(set) var fontfamilyName: String = Decorator.defaults.familyName
    
    init(withHaiku haiku: Haiku) {
        
        self.field1 = haiku.fields[safe: 0]?.text
        self.field2 = haiku.fields[safe: 1]?.text
        self.field3 = haiku.fields[safe: 2]?.text
        
        
        let decorator = haiku.decorator
        self.fontHexColor = decorator.fontHexColor
        self.fontSize = decorator.fontSize
        self.fontfamilyName = decorator.fontFamily
        
        self.haikuPictureURL = URL(string: haiku.pictureURL ?? "")
    }    
}
