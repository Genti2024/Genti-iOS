//
//  ImageGenerateUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation

protocol ImageGenerateUseCase {
    func requestImage(from userData: RequestImageData) async throws
}

final class ImageGenerateUseCaseImpl: ImageGenerateUseCase {
    
    let generateRepository: ImageGenerateRepository
    
    init(generateRepository: ImageGenerateRepository) {
        self.generateRepository = generateRepository
    }
    
    @MainActor
    func requestImage(from userData: RequestImageData) async throws {
        async let referenceS3Key = generateRepository.getS3Key(from: userData.referenceImageAsset?.asset)
        async let facesS3Keys = generateRepository.getS3Key(from: userData.faceImageAssets.map{ $0.asset })
        
        guard let selectedAngle = userData.selectedAngle, let selectedFrame = userData.selectedFrame, let selectedRatio = userData.selectedRatio else {
            throw GentiError.clientError(code: "Unwrapping", message: "각도,프레임,비율의 값이 비어있습니다")
        }
        try await generateRepository.requestGenerateImage(prompt: userData.description, poseURL: referenceS3Key, faceURLs: facesS3Keys, angle: selectedAngle, coverage: selectedFrame, ratio: selectedRatio)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
    }
}
