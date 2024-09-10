//
//  PhotoDetailUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/8/24.
//

import UIKit

protocol PhotoDetailUseCase {
    func downloadImage(to uiImage: UIImage) async -> Bool //완
}

final class PhotoDetailUseCaseImpl: PhotoDetailUseCase {
    
    let imageRepository: ImageRepository
    let hapticRepository: HapticRepository
    
    init(imageRepository: ImageRepository, hapticRepository: HapticRepository) {
        self.imageRepository = imageRepository
        self.hapticRepository = hapticRepository
    }
    
    @MainActor
    func downloadImage(to uiImage: UIImage) async -> Bool {
        let writeSuccess = await imageRepository.writeToPhotoAlbum(image: uiImage)
        hapticRepository.notification(type: writeSuccess ? .success : .error)
        return writeSuccess
    }
}
