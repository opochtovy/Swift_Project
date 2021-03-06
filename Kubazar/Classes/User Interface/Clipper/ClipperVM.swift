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
    public var cropedImageData: Data?
    
    private let haiku: Haiku
    
    init(client: Client, haiku: Haiku, imageData: Data) {
        
        self.haiku = haiku
        self.imageData = imageData
        super.init(client: client)
    }
    
    //MARK: - Public functions
    
    public func getEditorVM() -> EditorVM{
        
        return EditorVM(client: self.client, haiku: self.haiku, imageData: self.cropedImageData)
    }
}
