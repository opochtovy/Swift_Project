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
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(ForgotPasswordTitles.headerLabel, comment: "headerLabel")
        self.emailTextField.placeholder = NSLocalizedString(SignInTitles.emailPlaceholder, comment: "emailPlaceholder")
        self.descriptionLabel.text = NSLocalizedString(ForgotPasswordTitles.descriptionLabel, comment: "descriptionLabel")
        self.sendButton.setTitle(NSLocalizedString(ForgotPasswordTitles.sendButtonTitle, comment: "sendButtonTitle") + " ", for: .normal)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionSend(_ sender: UIButton) {
        
        let tabbedVC = TabbedController(client: self.viewModel.client)
        self.present(tabbedVC, animated: true, completion: nil)
    }
}
