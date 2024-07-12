//
//  ProfileUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation
import UIKit

final class ProfileUseCaseImpl: ProfileUseCase {
    
    let imageRepository: ImageRepository
    let userRepository: UserRepository
    
    init(imageRepository: ImageRepository, userRepository: UserRepository) {
        self.imageRepository = imageRepository
        self.userRepository = userRepository
    }
    
    func fetchInitalUserInfo() async throws -> UserInfoEntity {
        async let hasInProgressPhoto = userRepository.checkInProgress()
        async let completedPhotos = userRepository.getMyPictures(page: 0)
        return try await .init(hasInProgressPhoto: hasInProgressPhoto, completedImage: completedPhotos)
    }

    func getCompletedPhotos(page: Int) async throws -> MyImagesEntitiy {
        return try await userRepository.getMyPictures(page: page)
    }
    
    func load(from urlString: String) async -> UIImage? {
        return await imageRepository.load(from: urlString)
    }
}
