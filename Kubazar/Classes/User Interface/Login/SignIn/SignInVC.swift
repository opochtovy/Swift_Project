//
//  SignInVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class SignInVC: ViewController {
    
    var viewModel: SignInVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var wasLoadedBefore = false

    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = SignInVM(client: client)
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
        super.viewDidAppear(animated)
        
        if !self.wasLoadedBefore {
            self.alignRightImageForLoginButton()
        }
        self.wasLoadedBefore = true
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.cancelButtonTitle, comment: "Back Button Title"), style: .plain, target: self, action: #selector(SignInVC.cancel))
    }
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(SignInTitles.headerTitle, comment: "headerTitle")
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "emailPlaceholder")
        self.passwordTextField.placeholder = NSLocalizedString(SignInTitles.passwordPlaceholder, comment: "passwordPlaceholder")
        self.forgotPasswordButton.setTitle(NSLocalizedString(SignInTitles.forgotPasswordButton, comment: "forgotPasswordButton").uppercased(), for: .normal)
        self.loginButton.setTitle(NSLocalizedString(WelcomeTitles.registerButton, comment: "loginButton"), for: .normal)
    }
    
    //MARK: - Private functions
    
    @objc private func cancel() {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
    
    private func alignRightImageForLoginButton() {
        
        let buttonWidth = self.loginButton.frame.width
        let imageWidth = CGFloat(WelcomeConstants.registerImageWidth)
        self.loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - 2 * imageWidth, bottom: 0, right: 0)
        self.loginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2 * imageWidth, bottom: 0, right: 0)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionForgotPassword(_ sender: UIButton) {
        
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
    }
}
