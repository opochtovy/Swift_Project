//
//  UserThumbnail.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class UserThumbnail: UIView {

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var ivUser: UIImageView!
    @IBOutlet private weak var lbInitials: UILabel!
    
    public var viewModel: UserThumbnailVM? {
        
        didSet {
            
            ivUser.image = nil
            lbInitials.isHidden = true
            self.backgroundColor = UIColor.clear
            let placeholder = Placeholders.thumbnail.getRandom()
            
            if let url = viewModel?.userImageURL {
                
                self.ivUser.isHidden = false
                self.ivUser.af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: .crossDissolve(0.2))
            }
            else if let data = viewModel?.userImageData {
                
                self.ivUser.isHidden = false
                ivUser.image = UIImage.init(data: data)
            }
            else if let viewModel = viewModel {

                self.ivUser.image = placeholder
                self.lbInitials.isHidden = false
                self.lbInitials.text = viewModel.userInitials
                
                if viewModel.needBorders == true {
                    
                    self.addBorders()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        self.updateFontSize()
    }
    
    private func setup() {
        self.ivUser.layer.cornerRadius = self.ivUser.bounds.width / 2
        self.ivUser.layer.masksToBounds = true
        
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
        
        //defaults
        self.ivUser.image = nil
        self.backgroundColor = UIColor.clear
        self.lbInitials.text = ""
    }
    
    private func updateFontSize() {
        
        var size: CGFloat = 17.0
        
        switch self.bounds.width {
        case 20...29: size = 11.0
        case 30...39: size = 14.0
        case 40...50: size = 17.0
        default: break
        }
        
        self.lbInitials.font = lbInitials.font.withSize(size)
    }
    
    private func addBorders() {
        
        self.ivUser.layer.borderWidth = 1.0
        self.ivUser.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).cgColor
        self.ivUser.layer.masksToBounds = true
    }
}
