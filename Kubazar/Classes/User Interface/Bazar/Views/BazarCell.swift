//
//  BazarCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BazarCell: UITableViewCell {

    static let reuseID: String = "BazarCell"
    
    @IBOutlet private weak var ivAuthor: UIImageView!
    
    @IBOutlet private weak var svNames: UIStackView!
    @IBOutlet private weak var lbAuthorName: UILabel!
    @IBOutlet private weak var lbParticipants: UILabel!
    
    @IBOutlet private weak var vHaikuContent: HaikuPreview!
    @IBOutlet public weak var btnLike: UIButton!
    @IBOutlet private weak var lbDate: UILabel!
    
    public var viewModel: BazarCellVM! {
        
        didSet {
            
            self.updateContent()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()        
    }
    
    //MARK: - Actions
    
    @IBAction private func didPressActionButton(_ sender: UIButton) {
        
        self.viewModel.performAction(completionHandler: { (errorDescription, success) in
            
            self.updateLikeButton()
        })
    }
    
    //MARK: Public functions
    
    public func setImageForCell(imageURL: URL) {
        
        self.vHaikuContent.setImageForHaikuPreview(imageURL: imageURL)
    }
    
    public func isHaikuPreviewImageNil() -> Bool {
        
        return self.vHaikuContent.isImageNil()
    }
    
    //MARK: Private functions
    
    private func updateLikeButton() {
        
        self.btnLike.setTitle(viewModel.btnText, for: .normal)
        if viewModel.actionType == .like {
            
            self.btnLike.setImage(#imageLiteral(resourceName: "iconLike"), for: .normal)
            self.btnLike.isSelected = viewModel.isLiked
        }
    }
    
    private func updateContent() {
        
        self.lbAuthorName.text = viewModel.creatorName
        self.lbParticipants.text = viewModel.participants
        self.lbDate.text = viewModel.dateInfo
        self.svNames.axis = viewModel.isSingle ? .horizontal : .vertical
        
        self.btnLike.setTitle(viewModel.btnText, for: .normal)
        
        if viewModel.actionType == .like {
            
            self.btnLike.setImage(#imageLiteral(resourceName: "iconLike"), for: .normal)
            self.btnLike.isSelected = viewModel.isLiked
        }
        else {
            
            self.btnLike.setImage(#imageLiteral(resourceName: "iconPublish"), for: .normal)
            self.btnLike.isSelected = false
        }
        
        self.ivAuthor.image = nil
        
        if let url = viewModel.authorPictureURL {
            
            self.ivAuthor.af_setImage(withURL: url)
        }
        
        self.vHaikuContent.viewModel = viewModel.getPreviewVM()
    }
    
    private func setup() {
        
        self.ivAuthor.layer.cornerRadius = self.ivAuthor.bounds.height / 2
        self.ivAuthor.layer.borderWidth = 1.0
        self.ivAuthor.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).cgColor
        self.ivAuthor.layer.masksToBounds = true
        
        self.vHaikuContent.layer.shadowColor = UIColor.black.cgColor
        self.vHaikuContent.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.vHaikuContent.layer.shadowOpacity = 0.2
        self.vHaikuContent.layer.cornerRadius = 5.0
        self.vHaikuContent.layer.masksToBounds = false
    }
}
