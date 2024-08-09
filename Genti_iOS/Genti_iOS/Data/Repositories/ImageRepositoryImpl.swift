//
//  ImageRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import UIKit

import SDWebImageSwiftUI

final class ImageRepositoryImpl: NSObject, ImageRepository {
    
    private var continuation: CheckedContinuation<Bool, Never>?
    
    func load(from urlString: String) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            guard let url = URL(string: urlString) else { return continuation.resume(returning: nil) }
            SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                continuation.resume(returning: image)
                }
        }
    }

    func writeToPhotoAlbum(image: UIImage?) async -> Bool {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            guard let image = image else { return continuation.resume(returning: false) }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        }
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        continuation?.resume(returning: error == nil)
    }
}
