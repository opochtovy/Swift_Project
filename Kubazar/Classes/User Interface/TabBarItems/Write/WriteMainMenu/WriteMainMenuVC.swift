//
//  WriteMainMenuVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class WriteMainMenuVC: ViewController {
    
    private var viewModel: WriteMainMenuVM
    
    @IBOutlet weak var headerLabel: UILabel!

    //MARK: - LyfeCycle
    
    override init(client: Client) {
        
        self.viewModel = WriteMainMenuVM(client: client)
        super.init(client: client)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [] //iOS 10 and erlier.
        
        self.updateContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarAppearance()
    }
    
    //MARK: - Actions
    
    @IBAction func didPressOnePlayerStart(_ sender: UIButton) {
        
        let ctrl = PictureVC(client: self.client, viewModel: self.viewModel.getPictureVM())
        ctrl.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func didPressTwoPlayerStart(_ sender: UIButton) {
        
        let ctrl = FriendsVC(client: self.client, viewModel: self.viewModel.getFriendsVM(players: 1))
        ctrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func didPressThreePlayerStart(_ sender: UIButton) {
        
        let ctrl = FriendsVC(client: self.client, viewModel: self.viewModel.getFriendsVM(players: 2))
        ctrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        self.title = NSLocalizedString("WriteMainMenuTitles_title", comment: "")
        self.headerLabel.text = NSLocalizedString("WriteMainMenuTitles_headerLabel", comment: "").uppercased()
    }
    
    private func setStatusBarAppearance() {
        
        let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
        statusBarView?.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7411764706, blue: 0.7333333333, alpha: 1)
        statusBarView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }


}
