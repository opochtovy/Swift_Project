//
//  ForgotPasswordVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum ForgotPasswordTitles {
    static let headerLabel = "ForgotPasswordTitles_headerLabel"
    static let descriptionLabel = "ForgotPasswordTitles_descriptionLabel"
    static let sendButtonTitle = "ForgotPasswordTitles_sendButtonTitle"
}

class ForgotPasswordVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
}
