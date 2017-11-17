//
//  ChoosePictureButton.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ChoosePictureButton: UIButton {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet public weak var ivBackground: UIImageView!
    @IBOutlet public weak var lbTitle: UILabel!
    @IBOutlet public weak var lbDetails: UILabel!
    @IBOutlet public weak var ivButton: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
        self.setup()
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
        }
    }
    
    private func setup() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(ChoosePictureButton.didPressOnView))
        self.addGestureRecognizer(tap)
        
        self.showsTouchWhenHighlighted = true
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 20.0
        
        ivBackground.layer.cornerRadius = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isHighlighted = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.isHighlighted = false
    }
    
    @objc private func didPressOnView(_ sender: UIButton) {
        
        self.sendActions(for: .touchUpInside)
    }
}
