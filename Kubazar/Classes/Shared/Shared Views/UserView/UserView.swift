//
//  UserView.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class UserView: UIView {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbFirstName: UILabel!
    @IBOutlet private weak var lbLastName: UILabel!
    
    public var viewModel: UserViewVM? {
        didSet {
            
            self.lbFirstName.text = viewModel?.firstName ?? ""
            self.lbLastName.text = viewModel?.lastName ?? ""
            
            if let url = viewModel?.userImageURL {
                
                ivUser.af_setImage(withURL: url)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        addSubview(self.view)
        self.view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
    }
}
