//
//  NotificationCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class NotificationBaseCell: UITableViewCell {
    
    var viewModel: NotificationCellVM!
}

class NotificationCell: NotificationBaseCell {

    static public let reuseID = "NotificationCell"
    static let userPlaceholder = Placeholders.thumbnail.getRandom()
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var ivHaiku: UIImageView!
    @IBOutlet private weak var lbNoteInfo: UILabel!
    @IBOutlet private weak var lbDateInfo: UILabel!
    
    override var viewModel: NotificationCellVM! {
        
        didSet {
            
            ivUser.image = NotificationCell.userPlaceholder
            if let url = viewModel.userImageURL {
                
                ivUser.af_setImage(withURL: url)
            }
            
            ivHaiku.image = HaikuPreview.placeholder
            if let url = viewModel.haikuImageURL {
                
                ivHaiku.af_setImage(withURL: url)
            }
            
            lbNoteInfo.text = viewModel.notificationText
            lbDateInfo.text = viewModel.dateText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
        
        self.ivHaiku.layer.cornerRadius = 4.0
        self.ivHaiku.layer.masksToBounds = true
        
    }
}
