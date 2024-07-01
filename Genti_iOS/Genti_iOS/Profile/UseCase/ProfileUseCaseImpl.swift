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

    func getCompletedPhotos(page: Int) async throws -> MyImagesEntitiy {
        return try await userRepository.getMyPictures(page: page).toEntity
    }
}
