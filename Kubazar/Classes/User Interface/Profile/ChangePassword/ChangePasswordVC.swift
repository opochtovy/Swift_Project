//
//  ChangePasswordVC.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 28.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class ChangePasswordVC: ViewController, UITextFieldDelegate {
    
    static let titleText = "ChangePasswordVC_title"
    static let passwordLabelText = "ChangePasswordVC_passwordLabel"
    static let confirmPasswordLabelText = "ChangePasswordVC_confirmPasswordLabel"
    static let confirmPasswordPlaceholder = "ChangePasswordVC_confirmPasswordPlaceholder"

    var viewModel: ChangePasswordVM
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = ChangePasswordVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButtonWithoutChevron(title: ButtonTitles.cancelButtonTitle)
        self.setNavigationBarAppearance()
        self.localizeTitles()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.changeButtonTitle, comment: ""), style: .plain, target: self, action: #selector(ChangePasswordVC.actionChange))
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(ChangePasswordVC.titleText, comment: "")
        self.passwordLabel.text = NSLocalizedString(ChangePasswordVC.passwordLabelText, comment: "")
        self.confirmPasswordLabel.text = NSLocalizedString(ChangePasswordVC.confirmPasswordLabelText, comment: "")
        self.passwordTextField.placeholder = NSLocalizedString(ProfileVM.changePasswordTitle, comment: "")
        self.confirmPasswordTextField.placeholder = NSLocalizedString(ChangePasswordVC.confirmPasswordPlaceholder, comment: "")
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let password = textField.text, password.count == 0 {
            
            textField.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
        
        switch textField {
        case self.confirmPasswordTextField: self.actionChange()
        default: IQKeyboardManager.sharedManager().goNext()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let oldText = textField.text {
            
            let newText = oldText + string
            if newText != NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "") {
                
                textField.textColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.7254901961, alpha: 1)
            }
        }
        
        return true
    }
    
    // MARK: - Actions
    
    @objc private func actionChange() {
        
        if let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text  {
            
            if password != confirmPassword {
                
                self.showWrongResponseAlert(message: NSLocalizedString(StartEditProfileVC.wrongPasswordAlertMessage, comment: ""))
                return
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.client.authenticator.updateUserPassword(password: password, completionHandler: { errorDescription, success in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                if !success {
                    
                    self.showWrongResponseAlert(message: errorDescription)
                    
                } else {
                    
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

}
