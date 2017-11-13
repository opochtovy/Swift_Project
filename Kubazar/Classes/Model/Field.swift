//
//  Field.swift
//  Kubazar
//
//  Created by Mobexs on 11/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class Field {

    public var id: Int = 0
    public var text: String = ""
    public var owner: User
    
    init(user: User, text: String) {
        self.owner = user
        self.text = text
    }
}
