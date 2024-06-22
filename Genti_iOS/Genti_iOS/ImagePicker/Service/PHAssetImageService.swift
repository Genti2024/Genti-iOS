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
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo) async -> UIImage?
    func cancelLoad()
}
