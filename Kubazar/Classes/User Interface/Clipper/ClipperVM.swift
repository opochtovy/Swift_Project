//
//  ClipperVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/21/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class ClipperVM: BaseVM {
    
    public var imageData : Data
    
    private let haiku: Haiku
    
    init(client: Client, haiku: Haiku, imageData: Data) {
        
        self.haiku = haiku
        self.imageData = imageData
        super.init(client: client)
    }
}
