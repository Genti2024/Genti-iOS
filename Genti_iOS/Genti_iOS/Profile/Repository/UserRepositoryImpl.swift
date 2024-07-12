//
//  UserRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class UserRepositoryImpl: UserRepository {

    let requestService: RequestService
    
    init(requestService: RequestService) {
        self.requestService = requestService
    }
    
    func getMyPictures(page: Int) async throws -> MyImagesEntitiy {
        let dto: PageCommonPictureResponseDTO = try await requestService.fetchResponse(for: UserRouter.fetchMyPictures(page: page))
        return dto.toEntity
    }
    
    func checkInProgress() async throws -> Bool {
        return [true, false].randomElement()!
    }
}
