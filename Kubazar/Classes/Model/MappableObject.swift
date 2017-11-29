//
//  MappableObject.swift
//  Kubazar
//
//  Created by Mobexs on 11/27/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import ObjectMapper

class MappableObject: Mappable {
    
    required convenience init?(map: Map){
        
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
