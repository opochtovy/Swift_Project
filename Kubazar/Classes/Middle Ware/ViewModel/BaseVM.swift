//
//  BaseVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/4/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class BaseVM {
    
    typealias BaseCompletion = (_ success: Bool, _ error: Error?) -> Void
    
    var client: Client
    
    init(client: Client) {
        
        self.client = client
    }
    
}
