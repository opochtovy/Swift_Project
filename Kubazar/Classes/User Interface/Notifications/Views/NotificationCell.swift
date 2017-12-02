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
    static let placeholder = Placeholders.haiku.getRandom()
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var ivHaiku: UIImageView!
    @IBOutlet private weak var lbNoteInfo: UILabel!
    @IBOutlet private weak var lbDateInfo: UILabel!
    
    override var viewModel: NotificationCellVM! {
        
        didSet {
            
            ivUser.image = nil
            if let url = viewModel.userImageURL {
                
                ivUser.af_setImage(withURL: url)
            }
            
            ivHaiku.image = nil
            if let url = viewModel.haikuImageURL {
                
                ivHaiku.af_setImage(withURL: url, placeholderImage: HaikuPreview.placeholder, imageTransition: .crossDissolve(0.2))
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
