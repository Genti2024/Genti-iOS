//
//  ThirdGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI

@Observable final class ThirdGeneratorViewModel: GetImageFromImagePicker {
    
    var requestImageData: RequestImageData
    
    init(requestImageData: RequestImageData) {
        self.requestImageData = requestImageData
    }
    
    var referenceImages: [ImageAsset] = []
    
    var facesIsEmpty: Bool {
        return referenceImages.isEmpty
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(faces: referenceImages)
    }
    
    func getReferenceS3Key(imageAsset: ImageAsset?) async throws -> String? {
        if let referencePhAsset = imageAsset?.asset {
            guard let referenceKey = try await APIService.shared.uploadPHAssetToS3(phAsset: referencePhAsset) else {
                throw GentiError.serverError(code: "AWS", message: "referenceImage의 s3key가 null입니다")
            }
            return referenceKey
        }
        return nil
    }
    
    func getFaceS3Keys(imageAssets: [ImageAsset]) async throws -> [String] {
        return try await APIService.shared.uploadPHAssetToS3(phAssets: imageAssets.map { $0.asset }).compactMap{ $0 }
    }

    func generateImage() async throws {
        let request = self.requestData()
        async let referenceURL = getReferenceS3Key(imageAsset: request.referenceImageAsset)
        async let facesURLs = getFaceS3Keys(imageAssets: request.faceImageAssets)
        
        guard let selectedAngle = request.selectedAngle, let selectedFrame = request.selectedFrame, let selectedRatio = request.selectedRatio else {
            throw GentiError.clientError(code: "Unwrapping", message: "각도,프레임,비율의 값이 비어있습니다")
        }
        
        let _: Bool = try await APIService.shared.fetchResponse(for: GeneratorRouter.requestImage(prompt: request.description, poseURL: referenceURL, faceURLs: facesURLs, angle: selectedAngle, coverage: selectedFrame, ratio: selectedRatio))
    }
}

