//
//  ActionButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ActionButton: UIControl {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private var lbTitle: UILabel!
    @IBOutlet private var ivIcon: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.ivIcon.tintColor = isSelected ? UIColor.red.withAlphaComponent(0.8) : UIColor.white.withAlphaComponent(0.6)
        }
    }
    
    public var title: String = "" {
        didSet {
            self.lbTitle.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    @IBAction func didPressButton(_ sender: UIButton) {
        self.sendActions(for: .touchUpInside)
    }
}
