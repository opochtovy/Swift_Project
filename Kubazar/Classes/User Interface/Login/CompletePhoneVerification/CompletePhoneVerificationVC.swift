//
//  CompletePhoneVerificationVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class CompletePhoneVerificationVC: ViewController {
    
    static let backButtonTitle = "CompletePhoneVerificationVC_backButtonTitle"
    static let descriptionLabelText = "CompletePhoneVerificationVC_descriptionLabel"
    static let completionLabelText = "CompletePhoneVerificationVC_completionLabel"
    static let resendButtonTitle = "CompletePhoneVerificationVC_resendButtonTitle"
    
    var viewModel: CompletePhoneVerificationVM
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet var codeTextFields: [UITextField]!
    
    var number: String = ""
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeCodeTextFields()
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
    
    @objc private func actionDone() {
        
        let editProfileViewController = StartEditProfileVC(client: self.client)
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}
