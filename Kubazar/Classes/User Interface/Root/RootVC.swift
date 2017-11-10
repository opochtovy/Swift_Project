//
//  RootVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class RootVC: ViewController {
    
    private var viewModel: RootVM
    private var viewController: UIViewController?
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = RootVM(client: client)
        super.init(client: client)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client.authenticator.setStateOfCurrentUser()
        
        self.chooseController()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if let viewController = self.viewController {
            
            viewController.view.frame = self.view.bounds
        }
    }
    
    //MARK: - Notifications
    
    private func chooseController() {
        
        if let viewController = self.viewController {
            
            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        
        let welcomeViewController = WelcomeVC(client: self.client)
        let newViewController = UINavigationController(rootViewController: welcomeViewController)
        newViewController.isNavigationBarHidden = true
        self.viewController = newViewController
        
        if viewModel.loginAccepted {
            
            // left to be set
        }
        else {
            
//            let welcomeViewController = WelcomeVC(client: self.client)
//            let newViewController = UINavigationController(rootViewController: welcomeViewController)
//            self.viewController = newViewController
        }
        
        if let viewController = self.viewController {
            
            self.addChildViewController(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
    }
}
