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
            
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: requestOptions) { (imageData, dataUTI, orientation, info) in
                if let imageData = imageData {
                    continuation.resume(returning: imageData)
                } else {
                    continuation.resume(throwing: GentiError.clientError(code: "Unwrapping", message: "UIImage to Data변환 실패"))
                }
            }
        }
    }
}
