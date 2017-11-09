//
//  BazarCell.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class BazarCell: UITableViewCell {

    static let reuseID: String = "BazarCell"
    
    @IBOutlet private weak var ivAuthor: UIImageView!
    @IBOutlet private weak var lbAuthorName: UILabel!
    @IBOutlet private weak var lbParticipants: UILabel!
    @IBOutlet private weak var ivHaiku: UIImageView!
    
    @IBOutlet private weak var btnHaiku: UIButton!
    @IBOutlet private weak var lbDate: UILabel!
    
    
    public weak var viewModel: BazarCellVM! {
        
        didSet {
            
            self.lbAuthorName.text = viewModel.authorName
            self.lbParticipants.text = viewModel.participants
            self.lbDate.text = viewModel.dateInfo
            self.btnHaiku.setTitle(viewModel.btnText, for: .normal)
            
            //TODO: set images with af_setImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        addGradient()
    }
    
    private func setup() {
        
        self.ivAuthor.layer.cornerRadius = self.ivAuthor.bounds.height / 2
        self.ivAuthor.layer.borderWidth = 1.0
        self.ivAuthor.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).cgColor
        self.ivAuthor.layer.masksToBounds = true
        
        self.ivHaiku.layer.cornerRadius = 5.0
        self.ivHaiku.layer.masksToBounds = true
        
        self.ivHaiku.layer.shadowColor = UIColor.black.cgColor
        self.ivHaiku.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.ivHaiku.layer.shadowOpacity = 0.1
    }
    
    func addGradient() {

        let gradients = self.ivHaiku.layer.sublayers?.filter { $0 is CAGradientLayer}
        
        guard gradients == nil || gradients?.count == 0 else { return }

        let colors = [UIColor.white.withAlphaComponent(0).cgColor,
                      UIColor.white.withAlphaComponent(2).withAlphaComponent(0.2).cgColor,
                      UIColor.white.withAlphaComponent(0.3).cgColor,
                      UIColor.white.withAlphaComponent(0.4).cgColor,
                      UIColor.black.withAlphaComponent(0.5).cgColor]
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.ivHaiku.bounds
        gradientLayer.colors = colors;
        
        gradientLayer.locations = [0.0, 0.24, 0.5, 0.73, 1.0]
        
        self.ivHaiku.layer.insertSublayer(gradientLayer, at: UInt32(self.ivHaiku.layer.sublayers?.count ?? 0))
    }
}
