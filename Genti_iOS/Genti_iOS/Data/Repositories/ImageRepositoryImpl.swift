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

    func writeToPhotoAlbum(image: UIImage?) async -> Bool {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            guard let image = image else { return continuation.resume(returning: false) }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
            EventLogManager.shared.addUserPropertyCount(to: .downloadPhoto)
        }
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        continuation?.resume(returning: error == nil)
    }
}
