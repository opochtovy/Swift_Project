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
    
    @IBOutlet private weak var vUserThumbnail: UserThumbnail!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet public weak var btnCheck: UIButton!
    
    public var viewModel: FriendsCellVM! {
        
        didSet {
            
            lbName.text = viewModel.name
            self.btnCheck.isSelected = self.viewModel.isChosen            
            self.vUserThumbnail.viewModel = self.viewModel.getThumbnailVM()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - private functions
    private func setup() {
        
        self.addGestureRecognizer(UISwipeGestureRecognizer(target: nil, action: nil))
    }
    
}
