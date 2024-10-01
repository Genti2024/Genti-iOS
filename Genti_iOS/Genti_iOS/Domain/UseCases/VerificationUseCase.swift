//
//  VerificationUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 9/29/24.
//

import UIKit

protocol VerificationUseCase {
    func verification(from uiImage: UIImage) async throws
}

final class VerificationUseCaseImpl: VerificationUseCase {
    
    let generateRepository: ImageGenerateRepository
    
    init(generateRepository: ImageGenerateRepository) {
        self.generateRepository = generateRepository
    }
    
    func verification(from uiImage: UIImage) async throws {
        let verficationS3Key = try await generateRepository.getS3Key(from: uiImage)
        try await generateRepository.verificationImage(faceURL: verficationS3Key)
    }
}
