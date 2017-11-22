//
//  PictureVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Photos

enum PhotoError: Error {
    
    case nilImageData
    case accessDeclined
}

class PictureVM: BaseVM {

    private let haiku: Haiku
    private var assets: [PHAsset] = [] 
    public var accessAllowed : Bool {
    
        return PhotoLibraryManager.shared.isLibraryAccessAllowed
    }
    
    private var chosenImageData: Data?
    public var isCollectionExpanded: Bool = false
    
    init(client: Client, haiku: Haiku) {
        self.haiku = haiku
        super.init(client: client)
    }
    
    //MARK: - Public functions
    public func prepareModel() {
        
        guard self.accessAllowed == true else { return }
        self.assets = PhotoLibraryManager.shared.getAllPhotos()
        self.assets.append(contentsOf: PhotoLibraryManager.shared.getAllPhotos())
    }
    
    public func getClipperVM() -> ClipperVM? {
        
        guard let imageData = self.chosenImageData else { return nil }
        
        let haiku = Haiku()
        haiku.id = 25 // TODO
        haiku.creator = HaikuManager.shared.currentUser
        
        let vm = ClipperVM(client: self.client, haiku: haiku, imageData: imageData)
        return vm
    }
    
    public func getPictureCellVM(forIndexPath indexPath: IndexPath) -> PictureCellVM? {
        
        let asset = self.assets[indexPath.row]
        return PictureCellVM(withAsset: asset)
    }
    
    public func numberOfItems () -> Int{
        
        return self.assets.count
    }
    
    public func chooseRandomImage(completion: @escaping BaseCompletion) {
        
        guard self.accessAllowed == true else { completion(false, PhotoError.accessDeclined); return }
        
        let randomNumber = Int(arc4random_uniform(UInt32(self.assets.count)))
        let asset = self.assets[randomNumber]
        self.chooseImage(asset: asset, completion: completion)
    }
    
    public func chooseImage(atIndexPath indexPath: IndexPath, completion: @escaping BaseCompletion) {
        
        let asset = self.assets[indexPath.row]
        self.chooseImage(asset: asset, completion: completion)
    }
    
    public func chooseImage(withData imageData: Data?) {
        
        self.chosenImageData = imageData
    }
    
    //MARK: - Private functions

    private func chooseImage(asset: PHAsset, completion: @escaping BaseCompletion) {
        
        PhotoLibraryManager.shared.getImageFullData(fromAsset: asset) { (success, data) in
            
            if success == true && data != nil {
                
                self.chooseImage(withData: data)
                completion(true, nil)
            } else {
                completion(false, PhotoError.nilImageData)
            }
        }
    }
}
