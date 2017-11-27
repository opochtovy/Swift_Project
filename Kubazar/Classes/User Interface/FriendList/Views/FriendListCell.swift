//
//  FriendListCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/24/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    public static var reuseID = "FriendListCell"
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbUserName: UILabel!
    @IBOutlet private weak var lbhaikuCounter: UILabel!
    @IBOutlet private weak var btnInvite: UIButton!
    
    public var viewModel: FriendListCellVM! {
        didSet {
            
            lbUserName.text = viewModel.userName
            lbhaikuCounter.text = viewModel.haikuCounter
            
            lbhaikuCounter.isHidden = !viewModel.showInviteButton
            btnInvite.isHidden = !viewModel.showInviteButton
            
            ivUser.image = nil
            if let url = viewModel.userURL {
                
                ivUser.af_setImage(withURL: url)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {        
        
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
        self.btnInvite.layer.cornerRadius = 10.0
    }
}
