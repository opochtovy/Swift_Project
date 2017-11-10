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
    
    @IBOutlet private weak var vHaikuContent: UIView!
    @IBOutlet private weak var ivHaiku: UIImageView!
    @IBOutlet public weak var btnLike: UIButton!
    @IBOutlet private weak var lbDate: UILabel!
    
    @IBOutlet private weak var lbField1: UILabel!
    @IBOutlet private weak var lbField2: UILabel!
    @IBOutlet private weak var lbField3: UILabel!
    
    private var gradient: CAGradientLayer?
    
    public weak var viewModel: BazarCellVM! {
        
        didSet {
            
            self.lbAuthorName.text = viewModel.authorName
            self.lbParticipants.text = viewModel.participants
            self.lbDate.text = viewModel.dateInfo
            self.btnLike.setTitle(viewModel.btnText, for: .normal)

            self.svNames.axis = viewModel.isSingle ? .horizontal : .vertical
            
            self.lbField1.text = viewModel.field1
            self.lbField2.text = viewModel.field2
            self.lbField3.text = viewModel.field3
            
            let color : UIColor = viewModel.textColor == .black ? UIColor.black : UIColor.white
            self.lbField1.textColor = color
            self.lbField2.textColor = color
            self.lbField3.textColor = color
            
            self.ivHaiku.image = nil
            self.ivAuthor.image = nil
            
            if let url = viewModel.haikuPictureURL {
                
                 self.ivHaiku.af_setImage(withURL: url)
            }
            
            if let url = viewModel.authorPictureURL {
                
                self.ivAuthor.af_setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.addGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradientFrame()
    }
    
    override func draw(_ rect: CGRect) {
        self.updateGradientFrame()
    }
    
    //MARK: Private functions
    
    private func updateGradientFrame() {
        gradient?.frame = self.ivHaiku.bounds
    }
    
    private func setup() {
        
        self.ivAuthor.layer.cornerRadius = self.ivAuthor.bounds.height / 2
        self.ivAuthor.layer.borderWidth = 1.0
        self.ivAuthor.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).cgColor
        self.ivAuthor.layer.masksToBounds = true
        
        self.ivHaiku.layer.cornerRadius = 5.0
        self.ivHaiku.layer.masksToBounds = true
        
        self.vHaikuContent.layer.shadowColor = UIColor.black.cgColor
        self.vHaikuContent.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.vHaikuContent.layer.shadowOpacity = 0.2
        self.vHaikuContent.layer.cornerRadius = 5.0
        self.vHaikuContent.layer.masksToBounds = false
    }
    
    func addGradient() {

        let gradients = self.ivHaiku.layer.sublayers?.filter { $0 is CAGradientLayer}
        
        guard gradients == nil || gradients?.count == 0 else { return }

        let firstColor = UIColor.clear.cgColor
        let secondColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        let colors = [firstColor,
                      firstColor,
                      firstColor,
                      firstColor,
                      secondColor]
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.ivHaiku.bounds
        gradientLayer.colors = colors;
        
        gradientLayer.locations = [0.0,
                                   0.24,
                                   0.5,
                                   0.73,
                                   1.0]
        
        self.ivHaiku.layer.insertSublayer(gradientLayer, at: UInt32(self.ivHaiku.layer.sublayers?.count ?? 0))
        
        self.gradient = gradientLayer
    }
}
