//
//  ProfileHeaderCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class ProfileHeaderCellVM {
    
    private(set) var headerTitle: String = ""
    private(set) var buttonTitle: String = ""
    
    init(header: String, button: String) {
        
        headerTitle = header
        buttonTitle = button
    }
    
}
