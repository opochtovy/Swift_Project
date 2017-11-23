//
//  PickFontButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/23/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PickFontButton: UIButton {
    
    private enum BorderColors {
        static let highlighted = #colorLiteral(red: 0.3803921569, green: 0.7098039216, blue: 0.7058823529, alpha: 1).cgColor
        static let basic =       #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1).cgColor
    }

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var vPickColor: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            
            self.vPickColor.layer.borderColor = isHighlighted == true ? BorderColors.highlighted : BorderColors.basic
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            self.vPickColor.backgroundColor = tintColor.withAlphaComponent(1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
        self.setup()
    }
    
    private func setup () {
        
        self.vPickColor.layer.cornerRadius = self.vPickColor.bounds.width / 2
        self.vPickColor.layer.borderColor = BorderColors.basic
        self.vPickColor.layer.borderWidth = 2.0
    }
}
