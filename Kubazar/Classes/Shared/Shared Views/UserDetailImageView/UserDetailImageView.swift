//
//  UserDetailImageView.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class UserDetailImageView: UIImageView {

    private var gradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradientFrame()
    }
    
    override func draw(_ rect: CGRect) {
        self.updateGradientFrame()
    }
    
    private func addGradient() {
        
        let gradients = self.layer.sublayers?.filter { $0 is CAGradientLayer}
        
        guard gradients == nil || gradients?.count == 0 else { return }
        
        let firstColor = UIColor.black

        let colors = [firstColor.withAlphaComponent(0.65).cgColor,
                      firstColor.withAlphaComponent(0.40).cgColor,
                      firstColor.withAlphaComponent(0.25).cgColor,
                      firstColor.withAlphaComponent(0.12).cgColor,
                      firstColor.withAlphaComponent(0.05).cgColor,
                      firstColor.withAlphaComponent(0.0).cgColor]
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors;
        
        gradientLayer.locations = [0.00,
                                   0.14,
                                   0.28,
                                   0.42,
                                   0.50,
                                   1.00]
        
        self.layer.insertSublayer(gradientLayer, at: UInt32(self.layer.sublayers?.count ?? 0))
        
        self.gradient = gradientLayer
    }
    
    private func updateGradientFrame() {
        
        self.frame = self.bounds
        self.gradient?.frame = self.bounds
    }
}
