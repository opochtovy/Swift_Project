//
//  CompleteEditProfileVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum CompleteEditProfileTitles {
    static let descriptionLabel = "CompleteEditProfileTitles_descriptionLabel"
    static let usernameLabel = "CompleteEditProfileTitles_usernameLabel"
    static let profileLabel = "CompleteEditProfileTitles_profileLabel"
}

class CompleteEditProfileVM: BaseVM {
    
    override init(client: Client) {
        super.init(client: client)
    }
    
    public var pickedImageData: Data = Data()
}
