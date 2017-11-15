//
//  TintMutableButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class TintMutableButton: UIButton {

    override var isSelected: Bool {
        
        didSet {
            
            super.isSelected = isSelected
            
            if isSelected {
                
                self.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
            }
            else {
                
                self.tintColor = UIColor.white.withAlphaComponent(0.6)
            }
        }
    }

}
