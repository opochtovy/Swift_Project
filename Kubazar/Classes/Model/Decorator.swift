//
//  Decorator.swift
//  Kubazar
//
//  Created by Mobexs on 11/20/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class Decorator {
    
    enum defaults {
        
        static let minFontSize: Float = 11.0
        static let maxFontSize: Float = 25.0
        
        static let familyName : String = ".SFUIDisplay"
        static let fontColor : String = "#000000"
        static let fontSize : Float = 17.0
    }
    
    public var fontSize: Float = defaults.fontSize
    public var fontFamily: String = defaults.familyName
    public var fontHexColor: String = defaults.fontColor
}
