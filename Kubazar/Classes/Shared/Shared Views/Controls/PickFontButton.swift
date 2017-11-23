//
//  PickFontButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/23/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PickFontButton: UIButton {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var vPickColor: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            
            self.vPickColor.layer.borderColor = isHighlighted == true ? #colorLiteral(red: 0.3803921569, green: 0.7098039216, blue: 0.7058823529, alpha: 1) : #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            print(tintColor)
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
        self.vPickColor.layer.borderColor = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
        self.vPickColor.layer.borderWidth = 2.0
    }
}
