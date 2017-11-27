//
//  TipView.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum TipPosition {
    
    case top
    case bottom
}

class TipView: UIView {
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var vContent: UIView!
    @IBOutlet private weak var ivTopArrow: UIImageView!
    @IBOutlet private weak var ivBottomArrow: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    
    private var position: TipPosition = .top
    
    static func showTip(fromView view: UIView, position: TipPosition, title: String) {
        
        TipView.hideTip(fromView: view)
        
        let height = view.bounds.height + 14
        let originY = position == .top ? view.bounds.origin.y - height : view.bounds.maxY
        let tipFrame = CGRect(x: view.bounds.origin.x, y: originY, width: view.bounds.width, height: height)
        
        let tipView = TipView(frame: tipFrame, position: position)
        tipView.lbTitle.text = title        
        
        view.addSubview(tipView)
    }
    
    static func hideTip(fromView view: UIView) {
        
        for subview in view.subviews {
            
            if subview.isKind(of: TipView.self) == true {
                
                subview.removeFromSuperview()
            }
        }
    }
    
    init(frame: CGRect, position: TipPosition) {
        
        self.position = position
        super.init(frame: frame)
        
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.view = loadViewFromNib()
        self.insertSubview(view, at: 0)
        self.view.frame = self.bounds
        self.setup()
    }
    
    private func setup() {
        
        self.vContent.layer.cornerRadius = 8.0
 
        self.ivBottomArrow.tintColor = self.vContent.backgroundColor
        self.ivTopArrow.tintColor = self.vContent.backgroundColor
        
        if self.position == .top {
            
            ivTopArrow.isHidden = true
        }
        else {
            
            ivBottomArrow.isHidden = true
        }
    }    
}
