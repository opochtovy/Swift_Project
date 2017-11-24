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
    
    /** false if user delete haiku from collection*/
    public var isActive: Bool = true
    
    /** defines user complete editing field*/
    public var isFinished: Bool = true
    
    init(user: User, text: String, finished: Bool = true) {
        self.owner = user
        self.text = text
    }
}
