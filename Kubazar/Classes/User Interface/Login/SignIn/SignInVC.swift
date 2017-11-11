//
//  SignInVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class SignInVC: ViewController {
    
    static let loginButtonTitle = "SignInVC_loginButtonTitle"
    
    var viewModel: SignInVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        
        self.edgesForExtendedLayout = []
        
        self.localizeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.wasLoadedBefore {
            self.loginButton.semanticContentAttribute = .forceRightToLeft
        }
        self.wasLoadedBefore = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(SignInTitles.headerLabel, comment: "headerLabel")
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "emailPlaceholder")
        self.passwordTextField.placeholder = NSLocalizedString(SignInTitles.passwordPlaceholder, comment: "passwordPlaceholder")
        self.forgotPasswordButton.setTitle(NSLocalizedString(SignInTitles.forgotPasswordButtonTitle, comment: "forgotPasswordButtonTitle").uppercased(), for: .normal)
        self.loginButton.setTitle(NSLocalizedString(SignInVC.loginButtonTitle, comment: "registerButtonTitle") + " ", for: .normal)
        self.cancelButton.setTitle(NSLocalizedString(ButtonTitles.cancelButtonTitle, comment: "Cancel Button Title"), for: .normal)
    }
    
    //MARK: - Actions
    
    @IBAction func actionCancel(_ sender: UIButton) {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
    
    
    @IBAction private func actionForgotPassword(_ sender: UIButton) {
        
        let forgotPasswordViewController = ForgotPasswordVC(client: self.client)
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
    }
}
