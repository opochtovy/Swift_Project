//
//  UIView+Extension.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
