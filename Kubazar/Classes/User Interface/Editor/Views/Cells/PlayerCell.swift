//
//  PlayerCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var vUserImageContainer: UIView!
    @IBOutlet private weak var lbStatus: UILabel!
    @IBOutlet private weak var btnStatus: UIButton!
    
    static let reuseID: String = "PlayerCell"
    
    public var viewModel: PlayerCellVM! {
        didSet {
            
            var statusImage: UIImage?
            
            switch viewModel.status {
            case .done: statusImage = #imageLiteral(resourceName: "iconCheck")
            case .waiting: statusImage = nil
            case .inProgress: statusImage = #imageLiteral(resourceName: "iconInProgress")
            }
            self.btnStatus.setImage(statusImage, for: .normal)
            self.lbStatus.text = viewModel.statusText
            
            if let url = self.viewModel.userURL {
                
                self.ivUser.af_setImage(withURL: url)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private functions
    
    private func setup() {
        
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
        
        self.vUserImageContainer.layer.cornerRadius = self.ivUser.bounds.width / 2
        
        self.vUserImageContainer.layer.shadowRadius = 4.0
        self.vUserImageContainer.layer.shadowOpacity = 0.2
        self.vUserImageContainer.layer.shadowColor = UIColor.black.cgColor
        self.vUserImageContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

}
