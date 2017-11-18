//
//  ColorVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/17/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ColorVC: UIViewController {
    
    @IBOutlet private weak var vContent: UIView!
    public var delegate: StyleEditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        
        self.vContent.layer.cornerRadius = 4.0
        self.vContent.layer.masksToBounds = true
        
        self.view.layer.cornerRadius = 4.0
        self.view.superview?.layer.cornerRadius = 4.0
    }
}
