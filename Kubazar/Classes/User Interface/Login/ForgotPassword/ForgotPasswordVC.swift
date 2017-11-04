//
//  ForgotPasswordVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ForgotPasswordVC: ViewController {
    
    var viewModel: ForgotPasswordVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
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
        
        self.localizeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.wasLoadedBefore {
            self.alignRightImageForSendButton()
        }
        self.wasLoadedBefore = true
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(ForgotPasswordTitles.headerLabel, comment: "headerLabel")
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "emailPlaceholder")
        self.descriptionLabel.text = NSLocalizedString(ForgotPasswordTitles.descriptionLabel, comment: "descriptionLabel")
        self.sendButton.setTitle(NSLocalizedString(ForgotPasswordTitles.sendButtonTitle, comment: "sendButtonTitle"), for: .normal)
    }
    
    private func alignRightImageForSendButton() {
        
        let buttonWidth = self.sendButton.frame.width
        let imageWidth = CGFloat(WelcomeConstants.arrowImageWidth)
        self.sendButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - 2 * imageWidth + 4, bottom: 0, right: 0)
        self.sendButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2 * imageWidth, bottom: 0, right: 0)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionSend(_ sender: UIButton) {
        
    }
}
