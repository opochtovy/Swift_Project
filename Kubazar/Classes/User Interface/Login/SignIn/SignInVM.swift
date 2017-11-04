//
//  SignInVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum SignInTitles {
    static let headerTitle = "SignInTitles_headerTitle"
    static let emailPlaceholder = "SignInTitles_emailPlaceholder"
    static let passwordPlaceholder = "SignInTitles_passwordPlaceholder"
    static let forgotPasswordButton = "SignInTitles_forgotPasswordButton"
}

class SignInVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
