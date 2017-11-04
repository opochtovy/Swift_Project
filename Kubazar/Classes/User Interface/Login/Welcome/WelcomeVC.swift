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
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton:  UIButton!
    
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
        super.viewDidAppear(animated)
        
        self.alignRightImageForLoginButton()
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(WelcomeTitles.headerTitle, comment: "headerTitle")
        self.descriptionLabel.text = NSLocalizedString(WelcomeTitles.description, comment: "description")
        self.signUpLabel.text = NSLocalizedString(WelcomeTitles.signUpLabel, comment: "signUpLabel")
        self.signUpButton.setTitle(NSLocalizedString(WelcomeTitles.signUpButton, comment: "signUpButton"), for: .normal)
        self.loginButton.setTitle(NSLocalizedString(WelcomeTitles.loginButton, comment: "loginButton"), for: .normal)
    }
    
    private func alignRightImageForLoginButton() {
        
        let buttonWidth = self.loginButton.frame.width
        let imageWidth = CGFloat(WelcomeConstants.loginImageWidth)
        self.loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - 2 * imageWidth, bottom: 0, right: 0)
        self.loginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2 * imageWidth, bottom: 0, right: 0)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
        print("self.loginButton.frame.width =", self.loginButton.frame.width)
    }
    
    @IBAction private func actionSignUp(_ sender: UIButton) {
        
    }
}
