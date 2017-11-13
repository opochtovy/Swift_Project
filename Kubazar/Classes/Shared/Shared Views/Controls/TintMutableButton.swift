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
                
                self.tintColor = UIColor.red.withAlphaComponent(0.8)
            }
            else {
                
                self.tintColor = UIColor.white.withAlphaComponent(0.6)
            }
        }
    }

}
