//
//  Bundle+Extensions.swift
//  Kubazar
//
//  Created by Mobexs on 11/22/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func getBaseURL() -> String {
        
        guard let dictionary = Bundle.main.infoDictionary else { return "" }
        return dictionary["BaseURL"] as! String
    }
}
