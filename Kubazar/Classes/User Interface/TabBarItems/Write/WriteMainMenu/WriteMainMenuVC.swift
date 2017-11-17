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
        
        self.updateContent()
    }
    
    //MARK: - Actions
    
    @IBAction func didPressOnePlayerStart(_ sender: UIButton) {
        
        let ctrl = PictureVC(client: self.client, viewModel: self.viewModel.getPictureVM())
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func didPressTwoPlayerStart(_ sender: UIButton) {
        
        let ctrl = FriendsVC(client: self.client, viewModel: self.viewModel.getFriendsVM(players: 1))
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func didPressThreePlayerStart(_ sender: UIButton) {
        
        let ctrl = FriendsVC(client: self.client, viewModel: self.viewModel.getFriendsVM(players: 2))
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    
    //MARK: - Private functions
    
    private func updateContent() {
        
        self.title = NSLocalizedString("WriteMainMenuTitles_title", comment: "")
        self.headerLabel.text = NSLocalizedString("WriteMainMenuTitles_headerLabel", comment: "").uppercased()
    }


}
