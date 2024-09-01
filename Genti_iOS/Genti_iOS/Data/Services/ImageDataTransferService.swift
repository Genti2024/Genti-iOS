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
            requestOptions.version = .current
            requestOptions.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { image, info in
                guard let image = image else {
                    continuation.resume(throwing: GentiError.clientError(code: "IMAGE", message: "추출할 수 없는 이미지 입니다"))
                    return
                }
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    continuation.resume(returning: imageData)
                } else {
                    continuation.resume(throwing: GentiError.clientError(code: "Unwrapping", message: "UIImage to Data 변환 실패"))
                }
            }
        }
    }
}
