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
        
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.backButtonTitle, comment: "Back Button Title"), style: .plain, target: self, action: #selector(ViewController.back))
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
    
    //MARK: - Public functions
    
    public func overrideBackButton() {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    //MARK: - Private functions
    
    @objc private func back() {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
}
