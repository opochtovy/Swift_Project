//
//  EditTextField.swift
//  Kubazar
//
//  Created by Mobexs on 11/20/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class EditTextField: UITextField {
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.layer.borderWidth = isSelected ? 0.5 : 0.0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        
        
        self.layer.borderColor = UIColor.black.cgColor
        self.contentVerticalAlignment = .center
    }
}
