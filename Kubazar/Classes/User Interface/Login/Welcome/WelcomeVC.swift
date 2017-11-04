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
        super.viewDidAppear(animated)
        
        if !self.wasLoadedBefore {
            self.alignRightImageForRegisterButton()
        }
        self.wasLoadedBefore = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.headerLabel.text = NSLocalizedString(WelcomeTitles.headerTitle, comment: "headerTitle")
        self.descriptionLabel.text = NSLocalizedString(WelcomeTitles.description, comment: "description")
        self.loginLabel.text = NSLocalizedString(WelcomeTitles.loginLabel, comment: "loginLabel")
        self.loginButton.setTitle(NSLocalizedString(WelcomeTitles.loginButton, comment: "loginButton").uppercased(), for: .normal)
        self.registerButton.setTitle(NSLocalizedString(WelcomeTitles.registerButton, comment: "registerButton"), for: .normal)
    }
    
    private func alignRightImageForRegisterButton() {
        
        let buttonWidth = self.registerButton.frame.width
        let imageWidth = CGFloat(WelcomeConstants.registerImageWidth)
        self.registerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - 2 * imageWidth, bottom: 0, right: 0)
        self.registerButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2 * imageWidth, bottom: 0, right: 0)
    }
    
    //MARK: - Actions
    
    @IBAction private func actionRegister(_ sender: UIButton) {
        
    }
    
    @IBAction private func actionLogin(_ sender: UIButton) {
        
        let signInViewController = SignInVC(client: self.client)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}
