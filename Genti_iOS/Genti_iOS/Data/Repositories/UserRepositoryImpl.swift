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
    
    func fetchPhotos() async throws -> [MyImagesEntitiy] {
        let dto: [PageCommonPictureResponseDTO] = try await requestService.fetchResponse(for: UserRouter.fetchMyPictures)
        return dto.map { $0.toEntity }
    }
    
    func getUserState() async throws -> UserState {
        let dto: UserStateDTO = try await requestService.fetchResponse(for: UserRouter.getUserState)
        switch dto.status {
        case "IN_PROGRESS":
            return .inProgress
        case "AWAIT_USER_VERIFICATION":
            guard let requestId = dto.pictureGenerateRequestId else { return .error }
            guard let photoInfo = dto.pictureGenerateResponse else { return .error }
            return .awaitUserVerification(.init(requestId: requestId, photoInfo: photoInfo))
        case "CANCELED":
            guard let requestId = dto.pictureGenerateRequestId else { return .error }
            return .canceled(requestId: requestId)
        case "NEW_REQUEST_AVAILABLE":
            return .canMake
        default:
            return .error
        }
    }
    
    func checkUserInProgress() async throws -> Bool {
        let dto: UserStateDTO = try await requestService.fetchResponse(for: UserRouter.getUserState)
        switch dto.status {
        case "IN_PROGRESS":
            return true
        default:
            return false
        }
    }
    
    func reportPhoto(responseId: Int, content: String) async throws {
        try await requestService.fetchResponse(for: UserRouter.reportPicture(responseId: responseId, content: content))
    }
    
    func scorePhoto(responseId: Int, rate: Int) async throws {
        try await requestService.fetchResponse(for: UserRouter.ratePicture(responseId: responseId, rate: rate))
    }
    
    func checkCompletedImage(responeId: Int) async throws {
        try await requestService.fetchResponse(for: UserRouter.checkCompletedImage(responeId: responeId))
    }
    
    func checkCanceledImage(requestId: Int) async throws {
        try await requestService.fetchResponse(for: UserRouter.checkCanceledImage(requestId: requestId))
    }
}
