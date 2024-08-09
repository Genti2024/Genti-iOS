//
//  PHAssetImageService.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit
import Photos

protocol PHAssetImageService {
    var imageManager: PHCachingImageManager { get }
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo, completionHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void)
    func cancelLoad()
}

final class PHAssetImageServiceImpl: PHAssetImageService {
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    private let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        return options
    }()
    
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo, completionHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        imageManager.requestImage(for: photoInfo.asset, targetSize: photoInfo.size, contentMode: .aspectFill, options: requestOptions, resultHandler: completionHandler)
    }
    
    func cancelLoad() {
        imageManager.stopCachingImagesForAllAssets()
    }
}
