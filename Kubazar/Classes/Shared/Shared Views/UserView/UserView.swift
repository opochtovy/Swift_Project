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
    @IBOutlet private weak var vUserThumbnail: UserThumbnail!
    @IBOutlet private weak var lbFirstName: UILabel!
    @IBOutlet private weak var lbLastName: UILabel!
    
    public var viewModel: UserViewVM? {
        didSet {
            
//            self.lbFirstName.text = viewModel?.firstName ?? ""
//            self.lbLastName.text = viewModel?.lastName ?? ""
            let nameComponents = viewModel?.displayName.components(separatedBy: " ")
            self.lbFirstName.text = nameComponents?.first
            self.lbLastName.text = nameComponents?.last
            self.vUserThumbnail.viewModel = viewModel?.getThumbnailVM()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        addSubview(self.view)
        self.view.frame = self.bounds
    }
}
