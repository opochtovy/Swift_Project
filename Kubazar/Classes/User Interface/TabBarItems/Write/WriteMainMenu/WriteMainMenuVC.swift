//
//  WriteMainMenuVC.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class WriteMainMenuVC: ViewController {
    
    var viewModel: WriteMainMenuVM
    
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
        
        self.localizeTitles()
    }
    
    //MARK: - Private functions
    
    private func localizeTitles() {
        
        self.title = NSLocalizedString(WriteMainMenuTitles.title, comment: "Title for Write Main Menu")
        
        self.headerLabel.text = NSLocalizedString(WriteMainMenuTitles.headerLabel, comment: "Header title").uppercased()
    }
}
