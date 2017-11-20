//
//  StartPhoneVerificationVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class StartPhoneVerificationVC: ViewController, CountryCodesVCDelegate, UITextFieldDelegate {
    
    static let titleText = "StartPhoneVerificationVC_title"
    static let descriptionLabelText = "StartPhoneVerificationVC_descriptionLabel"
    static let countryLabelText = "StartPhoneVerificationVC_countryLabel"
    static let numberLabelText = "StartPhoneVerificationVC_numberLabel"
    static let confirmNumberLabelText = "StartPhoneVerificationVC_confirmNumberLabel"
    static let numberPlaceholder = "StartPhoneVerificationVC_numberPlaceholder"
    static let confirmationAlertTitle = "StartPhoneVerificationVC_confirmationAlertTitle"
    static let confirmationAlertMessage = "StartPhoneVerificationVC_confirmationAlertMessage"
    static let emptyTextFieldsAlertTitle = "StartPhoneVerificationVC_emptyTextFieldsAlertTitle"
    static let emptyTextFieldsAlertMessage = "StartPhoneVerificationVC_emptyTextFieldsAlertMessage"
    
    var viewModel: StartPhoneVerificationVM
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var confirmNumberLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = StartPhoneVerificationVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.setBackButton(title: ButtonTitles.backButtonTitle)
        self.setNavigationBarAppearance()
        self.setStatusBarAppearance()
        self.localizeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.nextButtonTitle, comment: ""), style: .plain, target: self, action: #selector(StartPhoneVerificationVC.actionNext))
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(StartPhoneVerificationVC.titleText, comment: "")
        
        self.descriptionLabel.text = NSLocalizedString(StartPhoneVerificationVC.descriptionLabelText, comment: "")
        self.countryLabel.text = NSLocalizedString(StartPhoneVerificationVC.countryLabelText, comment: "")
        self.countryValueLabel.text = NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "")
        self.numberLabel.text = NSLocalizedString(StartPhoneVerificationVC.numberLabelText, comment: "")
        self.confirmNumberLabel.text = NSLocalizedString(StartPhoneVerificationVC.confirmNumberLabelText, comment: "")
        self.numberTextField.placeholder = NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "")
    }
    
    private func showConfirmationAlert() {

        guard let number = self.numberTextField.text else {
            
            self.showEmptyTextFieldsAlert()
            return
        }
        
        if self.countryValueLabel.text == NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "") || number.count < 8 {
            
            self.showEmptyTextFieldsAlert()
            return
        }
         
         let wholeNumberForMessage = self.viewModel.getCountryCode() + " " + number
         let wholeNumberToSend = self.viewModel.getCountryCode() + number
/*
        // for testing
        let number = ""
        let wholeNumberForMessage = self.viewModel.getCountryCode() + " " + number
        let wholeNumberToSend = "+375297509711"
        // end for testing
*/
        let message = wholeNumberForMessage + NSLocalizedString(StartPhoneVerificationVC.confirmationAlertMessage, comment: "")
        
        let alertController = UIAlertController(title: NSLocalizedString(StartPhoneVerificationVC.confirmationAlertTitle, comment: ""), message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.editButtonTitle, comment: ""), style: .cancel) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.yesButtonTitle, comment: ""), style: .default) { (_) in
            
            let completePhoneVerificationViewController = CompletePhoneVerificationVC(client: self.client)
            completePhoneVerificationViewController.viewModel.number = wholeNumberToSend
            self.navigationController?.pushViewController(completePhoneVerificationViewController, animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showEmptyTextFieldsAlert() {
        
        let alertTitle = NSLocalizedString(StartPhoneVerificationVC.emptyTextFieldsAlertTitle, comment: "")
        let alertMessage = NSLocalizedString(StartPhoneVerificationVC.emptyTextFieldsAlertMessage, comment: "")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.doneButtonTitle, comment: ""), style: .default) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let number = self.numberTextField.text, number.count == 0 {
            
            self.numberTextField.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
        
        self.showConfirmationAlert()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let oldText = textField.text {
            
            let newText = oldText + string
            if newText != NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "") {
                
                self.numberTextField.textColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.7254901961, alpha: 1)
            }
        }
        
        return true
    }
    
    // MARK: - CountryCodesVCDelegate
    
    func backButtonWasPressed(vc: CountryCodesVC, code: String, country: String) {
        
        self.countryValueLabel.textColor = #colorLiteral(red: 0.4078431373, green: 0.7333333333, blue: 0.7254901961, alpha: 1)
        self.countryValueLabel.text = code + " (" + country + ")"
        self.viewModel.setCountryCode(code: code)
    }
    
    // MARK: - Actions
    
    @objc private func actionNext() {
        
        self.showConfirmationAlert()
    }
    
    @IBAction func actionSelectCountryCode(_ sender: UIButton) {
        
        let countryCodesViewController = CountryCodesVC(client: self.client)
        countryCodesViewController.delegate = self
        self.navigationController?.pushViewController(countryCodesViewController, animated: true)
    }
}
