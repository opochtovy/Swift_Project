//
//  WelcomeVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum WelcomeTitles {
    static let headerLabel = "WelcomeTitles_headerLabel"
    static let descriptionLabel = "WelcomeTitles_descriptionLabel"
    static let loginLabel = "WelcomeTitles_loginLabel"
    static let loginButtonTitle = "WelcomeTitles_loginButtonTitle"
    static let registerButtonTitle = "WelcomeTitles_registerButtonTitle"
}

enum WelcomeConstants {
    static let arrowImageWidth = 18
}

class WelcomeVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
