//
//  StartPhoneVerificationVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class StartPhoneVerificationVC: ViewController {
    
    static let titleText = "StartPhoneVerificationVC_title"
    static let descriptionLabelText = "StartPhoneVerificationVC_descriptionLabel"
    static let countryLabelText = "StartPhoneVerificationVC_countryLabel"
    static let numberLabelText = "StartPhoneVerificationVC_numberLabel"
    static let confirmNumberLabelText = "StartPhoneVerificationVC_confirmNumberLabel"
    static let numberPlaceholder = "StartPhoneVerificationVC_numberPlaceholder"
    static let confirmationAlertTitle = "StartPhoneVerificationVC_confirmationAlertTitle"
    static let confirmationAlertMessage = "StartPhoneVerificationVC_confirmationAlertMessage"
    
    var viewModel: StartPhoneVerificationVM
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
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
        
        self.setNavigationBarAppearance()
        self.localizeTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setStatusBarAppearance()
    }
    
    //MARK: - Private functions
    
    private func setNavigationBarAppearance() {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(ButtonTitles.nextButtonTitle, comment: "Next Button Title"), style: .plain, target: self, action: #selector(StartPhoneVerificationVC.actionNext))
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(StartPhoneVerificationVC.titleText, comment: "Title for Phone Verification")
        
        self.descriptionLabel.text = NSLocalizedString(StartPhoneVerificationVC.descriptionLabelText, comment: "Description on Phone Verification")
        self.countryLabel.text = NSLocalizedString(StartPhoneVerificationVC.countryLabelText, comment: "Country Label on Phone Verification")
        self.numberLabel.text = NSLocalizedString(StartPhoneVerificationVC.numberLabelText, comment: "Number Label on Phone Verification")
        self.confirmNumberLabel.text = NSLocalizedString(StartPhoneVerificationVC.confirmNumberLabelText, comment: "Confirm Number Label on Phone Verification")
        self.numberTextField.placeholder = NSLocalizedString(StartPhoneVerificationVC.numberPlaceholder, comment: "Placelholder for Number TextField")
    }
    
    private func showConfirmationAlert() {
        
        let message = "451-987-8754" + NSLocalizedString(StartPhoneVerificationVC.confirmationAlertMessage, comment: "Description on Phone Verification")
        
        let alertController = UIAlertController(title: NSLocalizedString(StartPhoneVerificationVC.confirmationAlertTitle, comment: "Title for Confirmation alert on Phone Verification"), message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.editButtonTitle, comment: "Edit Button Title on Phone Verification"), style: .cancel) { (_) in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString(ButtonTitles.yesButtonTitle, comment: "Yes Button Title on Phone Verification"), style: .default) { (_) in
            
            let completePhoneVerificationViewController = CompletePhoneVerificationVC(client: self.client)
            completePhoneVerificationViewController.number = "451-987-8754"
            self.navigationController?.pushViewController(completePhoneVerificationViewController, animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        alertController.view.tintColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func actionNext() {
        
        self.showConfirmationAlert()
    }
}
