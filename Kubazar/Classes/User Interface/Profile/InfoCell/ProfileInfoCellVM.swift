//
//  ProfileInfoCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class ProfileInfoCellVM {
    
    private(set) var headerTitle: String = ""
    private(set) var hasDisclosureIcon: Bool = false
    
    init(header: String, hasDisclosure: Bool) {
        
        headerTitle = header
        hasDisclosureIcon = hasDisclosure
    }
    
}
