//
//  ProfileInfoCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {
    
    static let reuseID: String = "ProfileInfoCell"
    static let cellHeight: CGFloat = 50
    
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var disclosureImageView: UIImageView!
    @IBOutlet weak var bottomLine: UIView!
    
    public weak var viewModel: ProfileInfoCellVM! {
        
        didSet {
            
            self.infoTextField.text = viewModel.headerTitle
            if viewModel.hasDisclosureIcon {
                
                self.disclosureImageView.image = #imageLiteral(resourceName: "rightChevron")
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
}
