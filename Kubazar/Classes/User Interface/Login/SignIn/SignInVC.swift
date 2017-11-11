//
//  SignInVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignInVC: ViewController, UITextFieldDelegate {
    
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
    
    private func showShortPasswordAlert() {
        
        let alertTitle = NSLocalizedString(StartEditProfileVC.shortPasswordAlertTitle, comment: "Title for short password alert on Start Edit Profile")
        let alertMessage = NSLocalizedString(StartEditProfileVC.shortPasswordAlertMessage, comment: "Message for short password alert on Start Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Start Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showWrongEmailAlert() {
        
        let alertTitle = NSLocalizedString(StartEditProfileVC.wrongEmailAlertTitle, comment: "Title for wrong email alert on Start Edit Profile")
        let alertMessage = NSLocalizedString(StartEditProfileVC.wrongEmailAlertMessage, comment: "Message for wrong email alert on Start Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Start Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showWrongResponseAlert(message: String?) {
        
        let alertTitle = NSLocalizedString(CommonTitles.errorTitle, comment: "Error Title")
        var alertMessage = NSLocalizedString(ForgotPasswordVC.wrongResponseAlertMessage, comment: "Message for wrong respond alert on Start Edit Profile")
        if let message = message {
            
            alertMessage = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Forgot Password"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.emailTextField: self.passwordTextField.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        
        return true
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
        
        if let email = self.emailTextField.text, let password = self.passwordTextField.text  {
            
            if email.count < 7 {
                
                self.showWrongEmailAlert()
                return
                
            } else if password.count < 6 {
                
                self.showShortPasswordAlert()
                return
                
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.client.authenticator.signInWithEmailPassword(email: email, password: password, completionHandler: { errorDescription, success in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if !success {
                    
                    self.showWrongResponseAlert(message: errorDescription)
                    
                } else {
                    
                    let tabbedVC = TabbedController(client: self.viewModel.client)
                    self.present(tabbedVC, animated: true, completion: nil)
                }
            })
        }
    }
}
