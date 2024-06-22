//
//  PHAssetImageServiceImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit
import Photos

final class PHAssetImageServiceImpl: PHAssetImageService {
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    private let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        return options
    }()
    
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            imageManager.requestImage(for: photoInfo.asset, targetSize: photoInfo.size, contentMode: .aspectFill, options: requestOptions) { image, _ in
                DispatchQueue.main.async {
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    func cancelLoad() {
        imageManager.stopCachingImagesForAllAssets()
    }
}
