//
//  FriendListFooterView.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendListFooterView: UIView {

    @IBOutlet private weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
