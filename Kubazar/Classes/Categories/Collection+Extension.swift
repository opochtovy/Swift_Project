//
//  Collection+Extension.swift
//  Kubazar
//
//  Created by Mobexs on 11/10/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}
