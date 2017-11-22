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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.createTabBarViewControllers()
        self.setStatusBarAppearance()
    }
    
    //MARK: -  Private functions
    
    private func createTabBarViewControllers() {
        
        let bazarCtrl = BazarVC(client: self.viewModel.client)
        let bazarBarItem = UITabBarItem(title: NSLocalizedString(TabBarTitles.bazar, comment: "Bazar TabBar Item Title"), image: UIImage(named: TabBarImages.bazar), selectedImage: UIImage(named: TabBarImages.bazar))
        bazarCtrl.tabBarItem = bazarBarItem
        let bazarNavCtrl = UINavigationController(rootViewController: bazarCtrl)
        
        let writeViewController = WriteMainMenuVC(client: self.viewModel.client)
        let writeBarItem = UITabBarItem(title: NSLocalizedString(TabBarTitles.write, comment: "Write TabBar Item Title"), image: UIImage(named: TabBarImages.write), selectedImage: UIImage(named: TabBarImages.write))
        writeViewController.tabBarItem = writeBarItem
        let writeNavViewController = UINavigationController(rootViewController: writeViewController)
        
        let profileViewController = ProfileVC(client: self.viewModel.client)
        let profileBarItem = UITabBarItem(title: NSLocalizedString(TabBarTitles.profile, comment: ""), image: UIImage(named: TabBarImages.profile), selectedImage: UIImage(named: TabBarImages.profile))
        profileViewController.tabBarItem = profileBarItem
        let profileNavViewController = UINavigationController(rootViewController: profileViewController)
        
        self.viewControllers = [bazarNavCtrl, writeNavViewController, profileNavViewController]
    }

    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }

}
