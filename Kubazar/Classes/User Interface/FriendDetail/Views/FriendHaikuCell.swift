//
//  FriendHaikuCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class FriendHaikuCell: UICollectionViewCell {

    static let reuseID: String = "FriendHaikuCell"
    
    @IBOutlet private weak var ivHaiku: UIImageView!
    
    public var viewModel: FriendHaikuCellVM! {
        
        didSet {
            
            ivHaiku.image = nil
            
            if let url = viewModel.haikuImageURL {
                
                ivHaiku.af_setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
