//
//  ColorVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/22/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class ColorVM {
    
    private let decorator: Decorator
    
    init(withDecorator decorator: Decorator) {
        
        self.decorator = decorator
    }
    
    public func updateDecorator(withHexColor hexColor: String) {
        
        self.decorator.fontHexColor = hexColor
    }
}
