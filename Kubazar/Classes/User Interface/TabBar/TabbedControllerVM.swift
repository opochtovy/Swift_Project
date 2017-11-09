//
//  TabbedControllerVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/6/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum TabBarTitles {
    static let bazar = "TabBarTitles_bazar"
    static let write = "TabBarTitles_write"
}

enum TabBarImages {
    static let bazar = "bazarBarItem"
    static let write = "writeBarItem"
}

enum TabBarConstants {
    static let statusBarHeight = 20
}

class TabbedControllerVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
