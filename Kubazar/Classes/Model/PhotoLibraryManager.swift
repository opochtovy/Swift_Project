//
//  PhotoLibraryManager.swift
//  Kubazar
//
//  Created by Mobexs on 11/16/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import Photos

class PhotoLibraryManager {
    
    enum TargetSizes {
        
        static let small = CGSize(width: 150.0, height: 150.0)
    }
    
    typealias AccessRequestCompletion = (_ success: Bool) -> Void
    typealias ImageDataRequestCompletion = (_ success: Bool, _ imageData: Data?) -> Void
    
    static let shared: PhotoLibraryManager = PhotoLibraryManager()
    
    private lazy var imageManager: PHImageManager = {
        return PHImageManager()
    }()
    
    public var isLibraryAccessAllowed: Bool {
        
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    //MARK: - Public functions
    public func requestAccess(completion: @escaping AccessRequestCompletion) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            if status == .authorized {
                
                completion(true)
            }
            else {
                
                completion(false)
            }
        }
    }
    
    public func getAllPhotos() -> [PHAsset] {
    
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]        
        let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var assets : [PHAsset] = []
        
        result.enumerateObjects { (asset, _, _) in
            
            assets.append(asset)
        }

        return assets
    }
    
    /**
     Return closure with resized image data
     */
    public func getImageData(fromAsset asset: PHAsset, completion: @escaping ImageDataRequestCompletion) {

        let size = TargetSizes.small
        
        self.imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, options) in
            
            if let image = image {
                
                let data = UIImageJPEGRepresentation(image, 1.0)
                completion(true, data)
                
            }
            else {

                completion(false, nil)
            }
        }
    }
    
    /**
        Return closure with original image data.
     */
    public func getImageFullData(fromAsset asset: PHAsset, completion: @escaping ImageDataRequestCompletion) {
    
        self.imageManager.requestImageData(for: asset, options: nil) { (data, str, orientation, options) in
            
            if let data = data {
                
                completion(true, data)
            }
            else {
                
                completion(false, nil)
            }
        }
    }
}
