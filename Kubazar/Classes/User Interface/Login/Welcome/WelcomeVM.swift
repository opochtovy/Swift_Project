//
//  WelcomeVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum WelcomeTitles {
    static let headerTitle = "WelcomeTitles_headerTitle"
    static let description = "WelcomeTitles_description"
    static let signUpLabel = "WelcomeTitles_signUpLabel"
    static let signUpButton = "WelcomeTitles_signUpButton"
    static let loginButton = "WelcomeTitles_loginButton"
}

enum WelcomeConstants {
    static let loginImageWidth = 18
}

class WelcomeVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
