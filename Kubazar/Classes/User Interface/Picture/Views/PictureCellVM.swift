//
//  PictureCellVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Photos

class PictureCellVM {
    
    public var asset: PHAsset?
    
    init(withAsset asset: PHAsset) {
        
        self.asset = asset
    }
}
