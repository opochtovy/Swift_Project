//
//  PictureCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    static let reuseID: String = "PictureCell"
    
    @IBOutlet private weak var ivPicture: UIImageView!
    
    public var viewModel: PictureCellVM! {
        
        didSet {
            
            ivPicture.image = nil
            
            if let asset = viewModel.asset {
                
                PhotoLibraryManager.shared.getImageData(fromAsset: asset, completion: { (success, imageData) in
                    
                    if success && imageData != nil {
                        
                        self.ivPicture.image = UIImage(data: imageData!)
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        
        self.layer.cornerRadius = 5.0
    }

}
