//
//  ProfileUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class ProfileUseCaseImpl: ProfileUseCase {

    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchInitalUserInfo() async throws -> UserInfoEntity {
        async let hasInProgressPhoto = userRepository.checkInProgress()
        async let completedPhotos = userRepository.getMyPictures(page: 0).toEntity
        return try await .init(hasInProgressPhoto: hasInProgressPhoto, completedImage: completedPhotos)
    }

    func getCompletedPhotos(page: Int) async throws -> MyImagesEntitiy {
        return try await userRepository.getMyPictures(page: page).toEntity
    }
}
