//
//  Decorator.swift
//  Kubazar
//
//  Created by Mobexs on 11/20/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import UIKit

class Decorator {
    
    enum defaults {
        
        static let minFontSize: CGFloat = 11.0
        static let maxFontSize: CGFloat = 25.0
        static let familyName = UIFont.systemFont(ofSize: 17.0).familyName
    }
    
    public var fontSize: CGFloat = 17.0
    public var fontFamily: String = defaults.familyName
    public var fontColor: UIColor = .black
    
    public var font: UIFont? {
    
        return UIFont(name: fontFamily, size: fontSize)
    }
}
