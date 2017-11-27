//
//  FriendsCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    static var reuseID: String = "FriendsCell"
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet public weak var btnCheck: UIButton!
    
    public var viewModel: FriendsCellVM! {
        
        didSet {
            
            lbName.text = viewModel.name
            self.btnCheck.isSelected = self.viewModel.isChosen
            
            ivUser.image = nil
            
            if let url = self.viewModel.iconUrl {
                
                ivUser.af_setImage(withURL: url)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - private functions
    private func setup() {
        
        self.addGestureRecognizer(UISwipeGestureRecognizer(target: nil, action: nil))
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
    }
    
}
