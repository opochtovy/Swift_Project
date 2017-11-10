//
//  CompletePhoneVerificationVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class CompletePhoneVerificationVC: ViewController, UITextFieldDelegate {
    
    static let backButtonTitle = "CompletePhoneVerificationVC_backButtonTitle"
    static let descriptionLabelText = "CompletePhoneVerificationVC_descriptionLabel"
    static let completionLabelText = "CompletePhoneVerificationVC_completionLabel"
    static let resendButtonTitle = "CompletePhoneVerificationVC_resendButtonTitle"
    static let wrongCodeAlertTitle = "CompletePhoneVerificationVC_wrongCodeAlertTitle"
    static let wrongCodeAlertMessage = "CompletePhoneVerificationVC_wrongCodeAlertMessage"
    static let errorDuringSignInAlertTitle = "CompletePhoneVerificationVC_errorDuringSignInAlertTitle"
    static let errorDuringSignInAlertMessage = "CompletePhoneVerificationVC_errorDuringSignInAlertMessage"
    
    var viewModel: CompletePhoneVerificationVM
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet var codeTextFields: [UITextField]!
    
    var number: String = ""
    private var verificationCode: String = ""
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = CompletePhoneVerificationVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarAppearance()
        self.localizeTitles()
        
        self.sendPhoneNumber()
        
        self.allowOnlyOneDigitOnTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeCodeTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.leftBarButtonItem?.title = NSLocalizedString(CompletePhoneVerificationVC.backButtonTitle, comment: "Title for Phone Complete Verification")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title"), style: .plain, target: self, action: #selector(CompletePhoneVerificationVC.actionDone))
    }
    
    private func localizeTitles() {
        
        self.title = self.number
        
        self.descriptionLabel.text = NSLocalizedString(CompletePhoneVerificationVC.descriptionLabelText, comment: "Description on Complete Phone Verification")
        self.completionLabel.text = NSLocalizedString(CompletePhoneVerificationVC.completionLabelText, comment: "Completion Label title on Complete Phone Verification")
        self.resendButton.setTitle(NSLocalizedString(CompletePhoneVerificationVC.resendButtonTitle, comment: "Resent Button title on Complete Phone Verification"), for: .normal)
    }
    
    private func customizeCodeTextFields() {
        
        for code in self.codeTextFields {
            
            code.addBottomBorderWithColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1)
        }
    }
    
    private func sendPhoneNumber() {
        
        self.client.authenticator.sendPhoneNumber { success in
            
            print(success)
        }
/*
        PhoneAuthProvider.provider().verifyPhoneNumber("+375297509711", uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                // TODO: show error
                print("CompletePhoneVerification: error = ", error)
                return
            }
            guard let verificationID = verificationID else { return }
            print("verificationID =", verificationID)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.synchronize()
        }
*/
    }
    
    private func showWrongCodeAlert() {
        
        let alertTitle = NSLocalizedString(CompletePhoneVerificationVC.wrongCodeAlertTitle, comment: "Title for wrong code alert on Phone Verification")
        let alertMessage = NSLocalizedString(CompletePhoneVerificationVC.wrongCodeAlertMessage, comment: "Message for wrong code alert on Phone Verification")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Phone Verification"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorDuringSignInAlert() {
        
        let alertTitle = NSLocalizedString(CompletePhoneVerificationVC.errorDuringSignInAlertTitle, comment: "Title for error during sign in alert on Phone Verification")
        let alertMessage = NSLocalizedString(CompletePhoneVerificationVC.errorDuringSignInAlertMessage, comment: "Message for error during sign in alert on Phone Verification")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: "Done Button Title on Phone Verification"), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func allowOnlyOneDigitOnTextFields() {
        
        for textField in self.codeTextFields {
            
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 1, textField.text?.count == 0 {
            
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            return string == numberFiltered
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let textFieldIndex = self.codeTextFields.index(of: textField) {
            
            if textFieldIndex < self.codeTextFields.count - 1 {
                
                let nextTextField = self.codeTextFields[textFieldIndex + 1]
                nextTextField.becomeFirstResponder()
                
            } else {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    //MARK: - Actions
    
    @objc private func actionDone() {
        
//        let editProfileViewController = StartEditProfileVC(client: self.client)
//        self.navigationController?.pushViewController(editProfileViewController, animated: true)
        
        self.verificationCode = ""
        for textField in self.codeTextFields {
            
            if let text = textField.text {
                
                self.verificationCode.append(text)
            }
        }
        
        print("self.verificationCode =", self.verificationCode)
        print("number of textFields =", self.codeTextFields.count)
        
        if self.verificationCode.count < self.codeTextFields.count {
            
            self.showWrongCodeAlert()
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.client.authenticator.signInWithPhoneNumber(verificationCode: self.verificationCode) { success in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if !success {
                
                self.showErrorDuringSignInAlert()
            }
        }
/*
        let verificationID = UserDefaults.standard.value(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: self.verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                return
            }
            
            // User is signed in
            if let user = user {
                
                print("Phone number: \(user.phoneNumber ?? "nil")")
                let userInfo: Any? = user.providerData[0]
                print(userInfo ?? "no user info")
            }
        }
*/
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if textField.text?.utf16.count == 1, let textFieldIndex = self.codeTextFields.index(of: textField) {
            
            if textFieldIndex < self.codeTextFields.count - 1 {
                
                let nextTextField = self.codeTextFields[textFieldIndex + 1]
                nextTextField.becomeFirstResponder()
                
            } else {
                textField.resignFirstResponder()
            }
        }
    }
}