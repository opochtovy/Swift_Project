//
//  ForgotPasswordVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class ForgotPasswordVC: ViewController, UITextFieldDelegate {
    
    static let wrongResponseAlertTitle = "ForgotPasswordVC_wrongResponseAlertTitle"
    static let wrongResponseAlertMessage = "ForgotPasswordVC_wrongResponseAlertMessage"
    
    var viewModel: ForgotPasswordVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var wasLoadedBefore = false
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = ForgotPasswordVM(client: client)
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
        super.viewDidAppear(animated)
        
        if !self.wasLoadedBefore {
            self.sendButton.semanticContentAttribute = .forceRightToLeft
        }
        self.wasLoadedBefore = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(ForgotPasswordTitles.headerLabel, comment: "headerLabel")
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "emailPlaceholder")
        self.descriptionLabel.text = NSLocalizedString(ForgotPasswordTitles.descriptionLabel, comment: "descriptionLabel")
        self.sendButton.setTitle(NSLocalizedString(ForgotPasswordTitles.sendButtonTitle, comment: "sendButtonTitle") + " ", for: .normal)
        self.backButton.setTitle(" " + NSLocalizedString(ButtonTitles.backButtonTitle, comment: "Back Button Title"), for: .normal)
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
        
        let alertTitle = NSLocalizedString(ForgotPasswordVC.wrongResponseAlertTitle, comment: "Title for wrong respond alert on Start Edit Profile")
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
        
        self.actionSend(self.sendButton)
        
        return true
    }
    
    //MARK: - Actions
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        if let navigationController = self.navigationController {
            
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction private func actionSend(_ sender: UIButton) {
        
        if let email = self.emailTextField.text  {
            
            if email.count < 7 {
                
                self.showWrongEmailAlert()
                return
                
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.client.authenticator.resetPassword(email: email, completionHandler: { errorDescription, success in
                
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
