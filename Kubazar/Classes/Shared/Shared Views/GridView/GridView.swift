//
//  GridView.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    @IBOutlet private weak var view: UIView!

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
    }
}
