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
    
    func fetchPhotos(page: Int) async throws -> MyImagesEntitiy {
        let dto: PageCommonPictureResponseDTO = try await requestService.fetchResponse(for: UserRouter.fetchMyPictures(page: page))
        return dto.toEntity
    }
    
    // MARK: - 추후 수정
    func checkUserStatus() async throws -> Bool {
        return [true, false].randomElement()!
    }
    
    func reportPhoto(id: Int, content: String) async throws {
        try await requestService.fetchResponse(for: UserRouter.reportPicture(id: id, content: content))
    }
    
    // MARK: - 추후 수정
    func scorePhoto(rate: Int) async throws {
        return try await requestService.fetchResponse(for: UserRouter.ratePicture(id: 1, rate: rate))
    }
}
