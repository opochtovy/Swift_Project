//
//  BazarDetailVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class BazarDetailVC: ViewController {

    let viewModel: BazarDetailVM
    
    @IBOutlet private weak var lbDate: UILabel!
    
    @IBOutlet private weak var ivHaiku: UIImageView!
    
    @IBOutlet private weak var vUser1: UserView!
    @IBOutlet private weak var vUser2: UserView!
    @IBOutlet private weak var vUser3: UserView!
    
    //MARK: - LifeCycle
    init(client: Client, viewModel: BazarDetailVM) {
        self.viewModel = viewModel
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconPoint"), style: .plain, target: self, action: #selector(BazarDetailVC.didPressPointButton(_:)))
        barButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = barButton
        
        self.updateContent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarAppearance()
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "iconClose"), style: .plain, target: self, action: #selector(BazarDetailVC.didPressCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = back
    }
    
    //MARK:- Actions
    
    @objc private func didPressCloseButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didPressPointButton(_ sender: UIButton) {
        
    }
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        lbDate.text = viewModel.dateText
        
        if let url = viewModel.haikuImageURL {
            
            self.ivHaiku.af_setImage(withURL: url)
        }
        
        vUser1.viewModel = self.viewModel.getUserViewVM(forIndex: 0)
        vUser2.viewModel = self.viewModel.getUserViewVM(forIndex: 1)
        vUser3.viewModel = self.viewModel.getUserViewVM(forIndex: 2)
    }
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = UIColor.clear
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}