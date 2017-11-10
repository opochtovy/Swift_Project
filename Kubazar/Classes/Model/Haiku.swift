//
//  Haiku.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum HaikuTextColor {
    case black
    case white
}

class Haiku {
    
    public var id : Int = 0
    public var date: Date?
    public var pictureURL: String?
    public var likesCount: Int = 0
    public var author: User?
    public var participants: [User] = []
    public var fields: [String] = []
    public var color: HaikuTextColor = .black
}

