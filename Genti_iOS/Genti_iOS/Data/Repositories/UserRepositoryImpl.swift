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
    
    func checkUserIsVerfied() async throws -> Bool {
        return try await requestService.fetchResponse(for: UserRouter.getUserIsVerified)
    }
    
    
    func checkInspectionTime() async throws -> CheckInspectionTimeEntity {
        let dto: MaintenanceInfoResponseDTO = try await requestService.fetchResponse(for: UserRouter.getInspectionTimeInfo)
        return dto.toEntitiy
    }
    
    
    func getOpenChatInfo() async throws -> GentiOpenChatAgreementType {
        let dto: OpenChatDTO = try await requestService.fetchResponse(for: UserRouter.fetchOpenChatInfo)
        if dto.accessible {
            guard let openChapUrl = dto.url, let count = dto.count else { throw GentiError.serverError(code: "Empty", message: "url과 count가 null입니다") }
            return .agree(.init(openChatUrl: openChapUrl, numberOfPeople: count))
        } else {
            return .disagree
        }
    }
    
    func fetchPhotos() async throws -> [MyImagesEntitiy] {
        let dto: [PageCommonPictureResponseDTO] = try await requestService.fetchResponse(for: UserRouter.fetchMyPictures)
        return dto.map { $0.toEntity }
    }
    
    func checkUserHasCanceledOrAwaitedRequest() async throws -> Bool {
        let dto: UserStateDTO = try await requestService.fetchResponse(for: UserRouter.getUserState)
        if dto.status == "CANCELED" {
            EventLogManager.shared.logEvent(.pushNotificationTap(false))
            return true
        } else if dto.status == "AWAIT_USER_VERIFICATION" {
            EventLogManager.shared.logEvent(.pushNotificationTap(true))
            return true
        } else {
            return false
        }
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
