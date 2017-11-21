//
//  PlayerCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbStatus: UILabel!
    @IBOutlet private weak var btnStatus: UIButton!
    
    public var viewModel: PlayerCell! {
        didSet {
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private functions
    
    private func setup() {
        
        
    }

}
