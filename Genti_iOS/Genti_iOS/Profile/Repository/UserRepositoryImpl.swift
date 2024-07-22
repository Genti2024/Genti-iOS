//
//  UserRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
    func ratePhoto(rate: Int) async throws {}
    

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
    
    func reportPhoto(id: Int, content: String) async throws {
        try await requestService.fetchResponse(for: UserRouter.reportPicture(id: id, content: content))
    }
}
