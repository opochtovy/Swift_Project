//
//  RememberCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class RememberCell: NotificationBaseCell {

    static public let reuseID = "RememberCell"
    @IBOutlet private weak var ivHaiku: UIImageView!
    
    override var viewModel: NotificationCellVM! {
        
        didSet {
            ivHaiku.image = nil
            if let url = viewModel.haikuImageURL {
                
                ivHaiku.af_setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.ivHaiku.layer.cornerRadius = 4.0
        self.ivHaiku.layer.masksToBounds = true
    }
    
}
