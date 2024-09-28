//
//  ProfileUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation
import UIKit

protocol ProfileUseCase {
    func fetchInitalUserInfo() async throws -> UserInfoEntity
    func getCompletedPhotos() async throws -> [MyImagesEntitiy]
}

final class ProfileUseCaseImpl: ProfileUseCase {
    
    let imageRepository: ImageRepository
    let userRepository: UserRepository
    
    init(imageRepository: ImageRepository, userRepository: UserRepository) {
        self.imageRepository = imageRepository
        self.userRepository = userRepository
    }
    
    func fetchInitalUserInfo() async throws -> UserInfoEntity {
        let hasInProgressPhoto = try await userRepository.checkUserInProgress()
        let completedPhotos = try await userRepository.fetchPhotos()
        return .init(hasInProgressPhoto: hasInProgressPhoto, completedImage: completedPhotos)
    }

    func getCompletedPhotos() async throws -> [MyImagesEntitiy] {
        return try await userRepository.fetchPhotos()
    }
}

