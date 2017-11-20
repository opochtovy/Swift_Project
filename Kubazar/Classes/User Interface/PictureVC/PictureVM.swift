//
//  PictureVM.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Photos

class PictureVM: BaseVM {

    private var assets: [PHAsset] = [] 
    public var accessAllowed : Bool {
    
        return PhotoLibraryManager.shared.isLibraryAccessAllowed
    }
    
    public var chosenImageData: Data?
    public var isCollectionExpanded: Bool = false
    
    //MARK: - Public functions
    public func prepareModel() {
        
        guard self.accessAllowed == true else { return }
        self.assets = PhotoLibraryManager.shared.getAllPhotos()
        self.assets.append(contentsOf: PhotoLibraryManager.shared.getAllPhotos())
        self.assets.append(contentsOf: PhotoLibraryManager.shared.getAllPhotos())
        self.assets.append(contentsOf: PhotoLibraryManager.shared.getAllPhotos())
    }
    
    public func getEditorVM() -> EditorVM {
        
        let haiku = Haiku()
        haiku.id = 25 // TODO
        haiku.creator = HaikuManager.shared.currentUser
        
        
        return EditorVM(client: self.client, haiku: haiku)
    }
    
    public func getPictureCellVM(forIndexPath indexPath: IndexPath) -> PictureCellVM? {
        
        let asset = self.assets[indexPath.row]
        return PictureCellVM(withAsset: asset)
    }
    
    public func numberOfItems () -> Int{
        
        return self.assets.count
    }
    
    public func chooseRandomImage() {
        
        guard self.accessAllowed == true else { return }
        let randomNumber = Int(arc4random_uniform(UInt32(self.assets.count)))
        let asset = self.assets[randomNumber]
        self.chooseImage(asset: asset)
    }
    
    public func chooseImage(atIndexPath indexPath: IndexPath) {
        
        let asset = self.assets[indexPath.row]
        self.chooseImage(asset: asset)
    }
    
    //MARK: - Private functions

    private func chooseImage(asset: PHAsset) {
        
        PhotoLibraryManager.shared.getImageFullData(fromAsset: asset) { (success, data) in
            
            if success == true && data != nil {
                
                self.chosenImageData = data
            }
        }
    }
}
