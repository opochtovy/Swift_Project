//
//  TabbedControllerVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import UIKit

enum TabBarTitles {
    static let bazar = "TabBarTitles_bazar"
    static let friends = "TabBarTitles_friends"
    static let write = "TabBarTitles_write"
    static let notifications = "TabBarTitles_notifications"
    static let profile = "TabBarTitles_profile"
}

enum TabBarImages {
    static let bazar = "bazarBarItem"
    static let friends : UIImage = #imageLiteral(resourceName: "iconFriends")
    static let write = "writeBarItem"
    static let notifications: UIImage = #imageLiteral(resourceName: "iconNotification")
    static let profile = "profileBarItem"
    
}

enum TabBarConstants {
    static let statusBarHeight = 20
}

class TabbedControllerVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
