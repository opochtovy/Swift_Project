//
//  UIImage+Extensions.swift
//  Kubazar
//
//  Created by Mobexs on 11/9/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizePhoto(image: UIImage, scale: CGFloat) -> UIImage? {
        
        let newWidth = image.size.width / scale
        let newHeight = image.size.height / scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
