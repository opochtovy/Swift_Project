//
//  AccessAlertView.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class AccessAlertView: UIView {

    @IBOutlet private weak var view: UIView!
    @IBOutlet public weak var btnAskAccess: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
        self.setup()
    }
    
    private func setup() {
        
    }
}
