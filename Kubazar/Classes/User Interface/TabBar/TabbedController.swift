//
//  TabbedController.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum TabBarType {
    case bazar
    case friends
    case write
    case notifications
    case profile
}

class TabbedController: UITabBarController {
    
    var viewModel: TabbedControllerVM
    
    //MARK: -  LifeCycle
    
    init(client: Client) {
        
        self.viewModel = TabbedControllerVM(client: client)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabBarAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.createTabBarViewControllers()
    }
    
    //MARK: -  Private functions
    
    private func createTabBarViewControllers() {
        
        let welcomeViewController = WelcomeVC(client: self.viewModel.client)
        let tabOneBarItem = UITabBarItem(title: NSLocalizedString(TabBarTitles.bazar, comment: "Bazar TabBar Item Title"), image: UIImage(named: "bazarBarItem.png"), selectedImage: UIImage(named: "bazarBarItem.png"))
        welcomeViewController.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let forgotPasswordViewController = ForgotPasswordVC(client: self.viewModel.client)
        let tabTwoBarItem = UITabBarItem(title: NSLocalizedString(TabBarTitles.bazar, comment: "Bazar TabBar Item Title"), image: UIImage(named: "bazarBarItem.png"), selectedImage: UIImage(named: "bazarBarItem.png"))
        forgotPasswordViewController.tabBarItem = tabTwoBarItem
        
        self.viewControllers = [welcomeViewController, forgotPasswordViewController]
    }
    
    private func setTabBarAppearance() {
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
    }
}
