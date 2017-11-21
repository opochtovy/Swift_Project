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
    public var delegate: DecoratorDelegate?
    public var decorator: Decorator
    
    init(withDecorator decorator: Decorator) {
        self.decorator = decorator
        super.init(nibName: "ColorVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    @IBAction private func didPressColorButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: self.decorator.fontColor = UIColor.black
        case 1: self.decorator.fontColor = UIColor.white
        default: break
        }
        
        if let delegate = self.delegate {
            
          delegate.didUpdateDecorator(viewController: self)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
