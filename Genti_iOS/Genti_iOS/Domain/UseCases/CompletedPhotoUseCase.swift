//
//  CompletedPhotoUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/8/24.
//

import UIKit

protocol CompletedPhotoUseCase {
    func downloadImage(to uiImage: UIImage?) async -> Bool
    func reportPhoto(responseId: Int, content: String) async throws
}

final class CompletedPhotoUseCaseImpl: CompletedPhotoUseCase {

    let imageRepository: ImageRepository
    let hapticRepository: HapticRepository
    let userRepository: UserRepository
    
    init(imageRepository: ImageRepository, hapticRepository: HapticRepository, userRepository: UserRepository) {
        self.imageRepository = imageRepository
        self.hapticRepository = hapticRepository
        self.userRepository = userRepository
    }
    
    @MainActor
    func downloadImage(to uiImage: UIImage?) async -> Bool {
        guard let uiImage = uiImage else { return false }
        let writeSuccess = await imageRepository.writeToPhotoAlbum(image: uiImage)
        hapticRepository.notification(type: writeSuccess ? .success : .error)
        return writeSuccess
    }
    
    func reportPhoto(responseId: Int, content: String) async throws {
        try await userRepository.reportPhoto(responseId: responseId, content: content)
    }
}
