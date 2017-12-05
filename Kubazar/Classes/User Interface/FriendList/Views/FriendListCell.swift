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
    
    @IBOutlet private weak var vUserThumbnail: UserThumbnail!
    @IBOutlet private weak var lbUserName: UILabel!
    @IBOutlet private weak var lbhaikuCounter: UILabel!
    @IBOutlet public weak var btnInvite: UIButton!
    
    public var viewModel: FriendListCellVM! {
        didSet {
            
            lbUserName.text = viewModel.userName
            lbhaikuCounter.text = viewModel.haikuCounter
            lbhaikuCounter.isHidden = viewModel.showInviteButton
            btnInvite.isHidden = !viewModel.showInviteButton
            self.vUserThumbnail.viewModel = viewModel.getThumbnailVM()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {

        self.btnInvite.layer.cornerRadius = 10.0
    }
}
