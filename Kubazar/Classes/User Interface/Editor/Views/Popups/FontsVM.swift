//
//  FontsVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/22/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

class FontVM {
    
    private let decorator: Decorator
    
    public var minFontSize: Float = Decorator.defaults.minFontSize
    public var maxFontSize: Float = Decorator.defaults.maxFontSize
   
    public var fontFamilyName: String = Decorator.defaults.familyName
    public var fontSize: Float = Decorator.defaults.fontSize
    
    init(withDecorator decorator: Decorator) {
        
        self.decorator = decorator
        self.fontFamilyName = decorator.fontFamily
        self.fontSize = decorator.fontSize
    }
    
    public func updateDecoratorFontSize(value: Float) {
    
        self.decorator.fontSize = value
    }
    
    public func updateDecoratorFontFamily(fontFamilyName: String) {
        
        self.decorator.fontFamily = fontFamilyName
    }
}
