//
//  PlayerCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {    

    @IBOutlet private weak var vUserThumbnail: UserThumbnail!
    @IBOutlet private weak var lbStatus: UILabel!
    @IBOutlet private weak var btnStatus: UIButton!
    
    static let reuseID: String = "PlayerCell"
    
    public var viewModel: PlayerCellVM! {
        didSet {
            
            var statusImage: UIImage?
            
            switch viewModel.status {
            case .done: statusImage = #imageLiteral(resourceName: "iconCheck")
            case .none: statusImage = nil
            case .inProgress: statusImage = #imageLiteral(resourceName: "iconInProgress")
            }
            self.btnStatus.setImage(statusImage, for: .normal)
            self.lbStatus.text = viewModel.statusText
            self.vUserThumbnail.viewModel = viewModel.getThumbnailVM()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private functions
    
    private func setup() {

        self.vUserThumbnail.layer.masksToBounds = false
        self.vUserThumbnail.layer.shadowRadius = 4.0
        self.vUserThumbnail.layer.shadowOpacity = 0.2
        self.vUserThumbnail.layer.shadowColor = UIColor.black.cgColor
        self.vUserThumbnail.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

}
