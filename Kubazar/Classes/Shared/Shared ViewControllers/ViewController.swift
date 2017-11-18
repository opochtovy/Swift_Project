//
//  ViewController.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum ButtonTitles {
    static let backButtonTitle = "ButtonTitles_backButtonTitle"
    static let cancelButtonTitle = "ButtonTitles_cancelButtonTitle"
    static let doneButtonTitle = "ButtonTitles_doneButtonTitle"
    static let nextButtonTitle = "ButtonTitles_nextButtonTitle"
    static let editButtonTitle = "ButtonTitles_editButtonTitle"
    static let yesButtonTitle = "ButtonTitles_yesButtonTitle"
}

enum CommonTitles {
    static let errorTitle = "CommonTitles_errorTitle"
    static let wrongResponseMessage = "CommonTitles_wrongResponseMessage"
}

class ViewController: UIViewController {
    
    var client: Client
    
    //MARK: - LyfeCycle
    
    init(client: Client) {
        
        self.client = client
        
        let xibName = NSStringFromClass(type(of: self))
        let path = Bundle.main.path(forResource: xibName, ofType: "xib")
        let nibName = path != nil ? xibName : nil
        
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
    
    public func setBackButtonWithoutChevron(title: String) {
        
        let backButton = UIBarButtonItem(title: NSLocalizedString(title, comment: ""), style: .plain, target: self, action: #selector(ViewController.back))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    public func setBackButton(title: String) {
        
        let image = UIImage(named:"backChevronWhite")
        let button = UIButton(type: UIButtonType.custom)
        button.addTarget(self, action: #selector(ViewController.back), for: UIControlEvents.touchUpInside)
        button.setImage(image, for: UIControlState.normal)
        button.setTitle(" " + NSLocalizedString(title, comment: ""), for: .normal)
        button.sizeToFit()
        let backButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem  = backButton
    }
    
    //MARK: - Private functions
    
    @objc private func back() {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
}
