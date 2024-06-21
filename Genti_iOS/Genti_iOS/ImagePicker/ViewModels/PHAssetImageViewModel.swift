//
//  PHAssetImageViewModel.swift
//  Genti
//
//  Created by uiskim on 5/4/24.
//

import UIKit
import Combine
import Photos

@Observable 
final class PHAssetImageViewModel: ViewModel {
    
    struct State {
        var image: UIImage? = nil
    }
    
    enum Input {
        case viewWillAppear(PHAssetImageViewModel.PhotoInfo)
        case viewDidAppear
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear(let photoInfo):
            loadImage(for: photoInfo.asset, size: photoInfo.size)
        case .viewDidAppear:
            cancel()
        }
    }
    
    struct PhotoInfo {
        let size: CGSize
        let asset: PHAsset
    }
    
    var state: PHAssetImageViewModel.State
    
    init() {
        self.state = .init()
    }
    
    private let imageManager = PHCachingImageManager()

    private let requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .exact
        return options
    }()

    func loadImage(for asset: PHAsset, size: CGSize) {
        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: requestOptions
        ) {
            [weak self] result, _ in
            if let image = result {
                DispatchQueue.main.async {
                    self?.state.image = image
                }
            }
        }
    }
    
    func cancel() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
}
