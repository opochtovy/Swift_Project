//
//  Haiku.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

enum HaikuColorStyle {
    case black
    case white
}

class Haiku {
    
    public var id : Int = 0
    public var date: Date?
    public var pictureURL: String?
    public var likesCount: Int = 0
    public var author: User?    
    public var fields: [Field] = []
    public var color: HaikuColorStyle = .black
    public var published: Bool = false
    public var liked: Bool = false
}

extension Haiku {
    
    public var friends: [User] {
        return self.fields.flatMap{$0.owner}
    }
}

