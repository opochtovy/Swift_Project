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
        
        self.edgesForExtendedLayout = []
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
    
    public func setBackButtonWithoutChevron(title: String) {
        
        let backButton = UIBarButtonItem(title: NSLocalizedString(title, comment: ""), style: .plain, target: self, action: #selector(ViewController.back))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    public func setBackButton(title: String) {
        
        self.setBackButton(title: title, action: #selector(ViewController.back))
    }
    
    public func setBackButton(title: String, action: Selector) {
        
        let image = UIImage(named:"backChevronWhite")
        let button = UIButton(type: UIButtonType.custom)
        button.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        button.setImage(image, for: UIControlState.normal)
        button.setTitle(" " + NSLocalizedString(title, comment: ""), for: .normal)
        button.sizeToFit()
        let backButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem  = backButton
    }
    
    public func showWrongResponseAlert(message: String?) {
        
        let alertTitle = NSLocalizedString(CommonTitles.errorTitle, comment: "")
        var alertMessage = NSLocalizedString(CommonTitles.wrongResponseMessage, comment: "")
        if let message = message {
            
            alertMessage = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: ""), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    
    @objc private func back() {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
}
