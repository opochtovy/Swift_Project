//
//  StartEditProfileVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class StartEditProfileVC: ViewController, UITextFieldDelegate {
    
    static let wrongPasswordAlertTitle = "StartEditProfileVC_wrongPasswordAlertTitle"
    static let wrongPasswordAlertMessage = "StartEditProfileVC_wrongPasswordAlertMessage"
    static let shortPasswordAlertTitle = "StartEditProfileVC_shortPasswordAlertTitle"
    static let shortPasswordAlertMessage = "StartEditProfileVC_shortPasswordAlertMessage"
    static let wrongEmailAlertTitle = "StartEditProfileVC_wrongEmailAlertTitle"
    static let wrongEmailAlertMessage = "StartEditProfileVC_wrongEmailAlertMessage"

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
        
        self.edgesForExtendedLayout = []
        
        self.setNavigationBarAppearance()
        self.setTabBarAppearance()
        self.localizeTitles()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func setTabBarAppearance() {
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
    }
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title"), style: .plain, target: self, action: #selector(StartEditProfileVC.done))
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(StartEditProfileTitles.title, comment: "Title for Edit Profile")
        
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "Placelholder for Email TextField")
        self.passwordTextField.placeholder = NSLocalizedString(SignInTitles.passwordPlaceholder, comment: "Placelholder for Password TextField")
        self.confirmPasswordTextField.placeholder = NSLocalizedString(SignInTitles.confirmPasswordPlaceholder, comment: "Placelholder for Confirm Password TextField")
        
        self.descriptionLabel.text = NSLocalizedString(StartEditProfileTitles.descriptionLabel, comment: "Description on Edit Profile")
    }
    
    private func showWrongPasswordAlert() {
        
        let alertTitle = NSLocalizedString(StartEditProfileVC.wrongPasswordAlertTitle, comment: "Title for wrong password alert on Start Edit Profile")
        let alertMessage = NSLocalizedString(StartEditProfileVC.wrongPasswordAlertMessage, comment: "Message for wrong password alert on Start Edit Profile")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Start Edit Profile"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.confirmPasswordTextField: self.done()
        default: IQKeyboardManager.sharedManager().goNext()
        }
        
        return true
    }
    
    //MARK: - Actions
    
    @objc private func done() {

//        let completeEditProfileViewController = CompleteEditProfileVC(client: self.client)
//        self.navigationController?.pushViewController(completeEditProfileViewController, animated: true)

        if let email = self.emailTextField.text, let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text  {
            
            if email.count < 7 {
                
                self.showWrongEmailAlert()
                return
            
            } else if password.count < 6 {
                
                self.showShortPasswordAlert()
                return
                
            } else if password != confirmPassword {
                
                self.showWrongPasswordAlert()
                return
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.client.authenticator.linkEmailPasswordToAccount(email: email, password: password, completionHandler: { errorDescription, success in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if !success {
                    
                    self.client.authenticator.sessionManager.adapter = nil
                    self.showWrongResponseAlert(message: errorDescription)
                
                } else {
                    
                    print("linkEmailPasswordToAccount was successful")
                    
                    let completeEditProfileViewController = CompleteEditProfileVC(client: self.client)
                    self.navigationController?.pushViewController(completeEditProfileViewController, animated: true)
                }
                print(success)
            })
        }

    }
}
