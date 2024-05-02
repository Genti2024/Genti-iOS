//
//  AssetImageLoader.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import Foundation
import UIKit
import Photos

final class AssetImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    let imageManager: PHImageManager
    let imageRequsetOptions: PHImageRequestOptions
    
    init() {
        self.imageManager = PHImageManager()
        self.imageRequsetOptions = {
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.resizeMode = .fast
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            return options
        }()
        
    }
    
    func loadImage(for asset: PHAsset, size: CGSize) {
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageRequsetOptions) { [weak self] (result, info) in
            guard let image = result else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
