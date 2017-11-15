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
        
        self.localizeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.wasLoadedBefore {
            self.registerButton.semanticContentAttribute = .forceRightToLeft
        }
        self.wasLoadedBefore = true
        
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
    }
    
    //MARK: - Actions
    
    @IBAction private func actionRegister(_ sender: UIButton) {
        
        let phoneVerificationVC = StartPhoneVerificationVC(client: self.viewModel.client)
        let phoneVerificationNavViewController = UINavigationController(rootViewController: phoneVerificationVC)
        self.present(phoneVerificationNavViewController, animated: true, completion: nil)
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
        let signInViewController = SignInVC(client: self.client)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}
