//
//  WelcomeVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class WelcomeVC: ViewController {
    
    var viewModel: WelcomeVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton:  UIButton!
    
    private var wasLoadedBefore = false
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = WelcomeVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAppearance()
        self.localizeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.wasLoadedBefore {
            self.registerButton.semanticContentAttribute = .forceRightToLeft
        }
        self.wasLoadedBefore = true
        
        self.hideNavigationBar()
        self.setStatusBarAppearance()
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(WelcomeTitles.headerLabel, comment: "headerLabel")
        self.descriptionLabel.text = NSLocalizedString(WelcomeTitles.descriptionLabel, comment: "descriptionLabel")
        self.loginLabel.text = NSLocalizedString(WelcomeTitles.loginLabel, comment: "loginLabel")
        self.loginButton.setTitle(NSLocalizedString(WelcomeTitles.loginButtonTitle, comment: "loginButtonTitle"), for: .normal)
        self.registerButton.setTitle(NSLocalizedString(WelcomeTitles.registerButtonTitle, comment: "registerButtonTitle") + " ", for: .normal)
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = UIColor.clear
        statusBarView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    private func setNavigationBarAppearance() {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    private func hideNavigationBar() {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction private func actionRegister(_ sender: UIButton) {
        
        let phoneVerificationVC = StartPhoneVerificationVC(client: self.viewModel.client)
        self.navigationController?.pushViewController(phoneVerificationVC, animated: true)
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
        let signInViewController = SignInVC(client: self.client)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}
