//
//  PHAssetImageViewModel.swift
//  Genti
//
//  Created by uiskim on 5/4/24.
//

import UIKit
import Combine
import Photos

@Observable final class PHAssetImageViewModel {
    var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private let imageManager = PHCachingImageManager()

    private let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        return options
    }()

    func loadImage(
        for asset: PHAsset,
        size: CGSize
    ) {
        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: requestOptions
        ) {
            [weak self] result, _ in
            if let image = result {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    func cancel() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
}
