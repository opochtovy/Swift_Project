//
//  WelcomeVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class WelcomeVC: ViewController {
    
    var viewModel: WelcomeVM
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton:  UIButton!
    
    private var wasLoadedBefore = false
    
    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = WelcomeVM(client: client)
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
        super.viewWillAppear(animated)
        
        if !self.wasLoadedBefore {
            self.registerButton.semanticContentAttribute = .forceRightToLeft
        }
        self.wasLoadedBefore = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(WelcomeTitles.headerLabel, comment: "headerLabel")
        self.descriptionLabel.text = NSLocalizedString(WelcomeTitles.descriptionLabel, comment: "descriptionLabel")
        self.loginLabel.text = NSLocalizedString(WelcomeTitles.loginLabel, comment: "loginLabel")
        self.loginButton.setTitle(NSLocalizedString(WelcomeTitles.loginButtonTitle, comment: "loginButtonTitle"), for: .normal)
        self.registerButton.setTitle(NSLocalizedString(WelcomeTitles.registerButtonTitle, comment: "registerButtonTitle") + " ", for: .normal)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionRegister(_ sender: UIButton) {
        
        // just for test
        
        let tabbedVC = TabbedController(client: self.viewModel.client)
        self.present(tabbedVC, animated: true, completion: nil)
        
//        let phoneVerificationVC = StartPhoneVerificationVC(client: self.viewModel.client)
//        let phoneVerificationNavViewController = UINavigationController(rootViewController: phoneVerificationVC)
//        self.present(phoneVerificationNavViewController, animated: true, completion: nil)
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
        let signInViewController = SignInVC(client: self.client)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}
