//
//  Placeholders.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum Placeholders {
    
    static let images : [UIImage] = [#imageLiteral(resourceName: "profilePlaceHolder1"), #imageLiteral(resourceName: "profilePlaceHolder2"), #imageLiteral(resourceName: "profilePlaceHolder3"), #imageLiteral(resourceName: "profilePlaceHolder4"), #imageLiteral(resourceName: "profilePlaceHolder5"), #imageLiteral(resourceName: "profilePlaceHolder6"), #imageLiteral(resourceName: "profilePlaceHolder7"), #imageLiteral(resourceName: "profilePlaceHolder8"), #imageLiteral(resourceName: "profilePlaceHolder9")]
    
    case profile
    
    func getRandom() -> UIImage{
        
        switch self {
        case .profile:
            
            let index = Int(arc4random_uniform(UInt32(Placeholders.images.count)))
            return Placeholders.images[index]
        }
    }
}
