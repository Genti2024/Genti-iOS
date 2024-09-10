//
//  CompletedPhotoUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/8/24.
//

import UIKit

protocol CompletedPhotoUseCase {
    func downloadImage(to uiImage: UIImage?) async -> Bool //완
    func loadImage(url: String) async -> UIImage? //완
    func reportPhoto(responseId: Int, content: String) async throws //완
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
    
    func loadImage(url: String) async -> UIImage? {
        return await imageRepository.load(from: url)
    }
    
    func reportPhoto(responseId: Int, content: String) async throws {
        try await userRepository.reportPhoto(responseId: responseId, content: content)
    }
}
