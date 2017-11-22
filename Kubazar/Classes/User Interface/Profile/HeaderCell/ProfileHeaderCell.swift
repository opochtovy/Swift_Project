//
//  ProfileHeaderCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    
    static let reuseID: String = "ProfileHeaderCell"
    static let cellHeight: CGFloat = 50
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!

    public weak var viewModel: ProfileHeaderCellVM! {
        
        didSet {
            
            self.headerLabel.text = viewModel.headerTitle
            self.rightButton.setTitle(viewModel.buttonTitle, for: .normal)
            self.rightButton.isHidden = viewModel.buttonTitle.count == 0
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
}
