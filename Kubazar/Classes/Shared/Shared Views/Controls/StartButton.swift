//
//  StartButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class StartButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            
            self.layer.shadowOpacity = isHighlighted ? 0.3 : 0.1
        }
    }
    
    private func setup() {

        self.imageView?.contentMode = .scaleAspectFill
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = false        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 20.0
    }

}
