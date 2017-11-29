//
//  Placeholders.swift
//  Kubazar
//
//  Created by Mobexs on 11/28/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum Placeholders {
    
    static let imagesProfile : [UIImage] = [#imageLiteral(resourceName: "profilePlaceHolder1"), #imageLiteral(resourceName: "profilePlaceHolder2"), #imageLiteral(resourceName: "profilePlaceHolder3"), #imageLiteral(resourceName: "profilePlaceHolder4"), #imageLiteral(resourceName: "profilePlaceHolder5"), #imageLiteral(resourceName: "profilePlaceHolder6"), #imageLiteral(resourceName: "profilePlaceHolder7"), #imageLiteral(resourceName: "profilePlaceHolder8"), #imageLiteral(resourceName: "profilePlaceHolder9")]
    static let imagesThumbnails : [UIImage] = [#imageLiteral(resourceName: "UserPlaceholder1"), #imageLiteral(resourceName: "UserPlaceholder2"), #imageLiteral(resourceName: "UserPlaceholder3"), #imageLiteral(resourceName: "UserPlaceholder4"), #imageLiteral(resourceName: "UserPlaceholder5"), #imageLiteral(resourceName: "UserPlaceholder6"), #imageLiteral(resourceName: "UserPlaceholder7"), #imageLiteral(resourceName: "UserPlaceholder8"), #imageLiteral(resourceName: "UserPlaceholder10"), #imageLiteral(resourceName: "UserPlaceholder11"), #imageLiteral(resourceName: "UserPlaceholder12")]
    static let imagesHaiku : [UIImage] = [#imageLiteral(resourceName: "haikuPlaceholder")];
    
    case profile
    case thumbnail
    case haiku
    
    func getRandom() -> UIImage {
        
        switch self {
        case .profile:
            let index = Int(arc4random_uniform(UInt32(Placeholders.imagesProfile.count)))
            return Placeholders.imagesProfile[index]
        case .thumbnail:
            let index = Int(arc4random_uniform(UInt32(Placeholders.imagesThumbnails.count)))
            return Placeholders.imagesThumbnails[index]
        case .haiku:
            let index = Int(arc4random_uniform(UInt32(Placeholders.imagesHaiku.count)))
            return Placeholders.imagesHaiku[index]
        }
    }
}
