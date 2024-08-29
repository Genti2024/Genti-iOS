//
//  ImageDataTransferService.swift
//  Genti_iOS
//
//  Created by uiskim on 6/23/24.
//

import Foundation
import Photos

protocol ImageDataTransferService {
    func requestImageData(for asset: PHAsset) async throws -> Data
}

final class ImageDataTransferServiceImpl: ImageDataTransferService {
    func requestImageData(for asset: PHAsset) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { image, info in
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
                    continuation.resume(returning: imageData)
                } else {
                    continuation.resume(throwing: GentiError.clientError(code: "Unwrapping", message: "UIImage to Data 변환 실패"))
                }
            }
        }
    }
}
