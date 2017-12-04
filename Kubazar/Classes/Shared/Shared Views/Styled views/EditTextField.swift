//
//  EditTextField.swift
//  Kubazar
//
//  Created by Mobexs on 11/20/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class EditTextField: UITextField {
    
    var isAlfaHidden: Bool = false {
        didSet {
            self.alpha = isAlfaHidden ? 0.0 : 1.0
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.layer.borderWidth = isSelected ? 0.5 : 0.0
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            super.textColor = textColor
            let placeHolderTextColor = textColor?.withAlphaComponent(0.6)
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : placeHolderTextColor as Any])
            self.layer.borderColor = textColor?.cgColor
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
