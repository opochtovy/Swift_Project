//
//  SignInVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum SignInTitles {
    static let headerLabel = "SignInTitles_headerLabel"
    static let emailPlaceholder = "SignInTitles_emailPlaceholder"
    static let passwordPlaceholder = "SignInTitles_passwordPlaceholder"
    static let confirmPasswordPlaceholder = "SignInTitles_confirmPasswordPlaceholder"
    static let usernamePlaceholder = "SignInTitles_usernamePlaceholder"
    static let forgotPasswordButtonTitle = "SignInTitles_forgotPasswordButtonTitle"
}

class SignInVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
