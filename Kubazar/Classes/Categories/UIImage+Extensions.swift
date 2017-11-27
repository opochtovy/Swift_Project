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
    
    func imageWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(CGBlendMode.normal)
            
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            if let cgImage = self.cgImage {
                
                context.clip(to: rect, mask: cgImage)
                context.fill(rect)
            }
            
            var resultImage = UIImage()
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                
                resultImage = newImage
            }
            UIGraphicsEndImageContext()
            
            return resultImage
        }
        
        return self
    }
    
}
