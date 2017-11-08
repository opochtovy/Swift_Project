//
//  StartEditProfileVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class StartEditProfileVC: ViewController {

    var viewModel: StartEditProfileVM
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = StartEditProfileVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAppearance()
        self.setTabBarAppearance()
        self.localizeTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setStatusBarAppearance()
    }
    
    //MARK: - Private functions
    
    private func setTabBarAppearance() {
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
    }
    
    private func setNavigationBarAppearance() {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title"), style: .plain, target: self, action: #selector(StartEditProfileVC.done))
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(StartEditProfileTitles.title, comment: "Title for Edit Profile")
        
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "Placelholder for Email TextField")
        self.passwordTextField.placeholder = NSLocalizedString(SignInTitles.passwordPlaceholder, comment: "Placelholder for Password TextField")
        self.confirmPasswordTextField.placeholder = NSLocalizedString(SignInTitles.confirmPasswordPlaceholder, comment: "Placelholder for Confirm Password TextField")
        
        self.descriptionLabel.text = NSLocalizedString(StartEditProfileTitles.descriptionLabel, comment: "Description on Edit Profile")
    }
    
    @objc private func done() {
        
        
    }

}
