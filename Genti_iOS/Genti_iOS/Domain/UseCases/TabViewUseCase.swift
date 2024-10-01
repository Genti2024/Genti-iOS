//
//  TabViewUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/2/24.
//

import Foundation

protocol TabViewUseCase {
    func getUserState() async throws -> ImageGenerateState
    func checkCanceledImage(requestId: Int) async throws
    func getSavedBackgroundPush() async throws -> BackgroundPushType?
    func checkOpenChat() async throws -> GentiOpenChatAgreementType
    func checkInspectionTime() async throws -> InspectionTimeType
    func checkUserIsVerfied() async throws -> Bool
}

final class TabViewUseCaseImpl: TabViewUseCase {
    
    let userRepository: UserRepository
    let userdefaultRepository: UserDefaultsRepository
    
    init(userRepository: UserRepository, userdefaultRepository: UserDefaultsRepository) {
        self.userRepository = userRepository
        self.userdefaultRepository = userdefaultRepository
    }
    
    func checkUserIsVerfied() async throws -> Bool {
        return try await userRepository.checkUserIsVerfied()
    }
    
    func checkInspectionTime() async throws -> InspectionTimeType {
        let inspectionTimeInfo = try await userRepository.checkInspectionTime()
        return inspectionTimeInfo.canMake ? .canMake : .cantMake(title: inspectionTimeInfo.message)
    }
    
    func getUserState() async throws -> ImageGenerateState {
        let userState = try await userRepository.getUserState()
        switch userState {
        case .inProgress:
            return .waitComplete
        case .canMake:
            switch try await self.checkInspectionTime() {
            case .canMake:
                return try await self.checkUserIsVerfied() ? .canMake : .needCertification
            case .cantMake(let timeInfo):
                return .Inspection(time: timeInfo)
            }
        case .awaitUserVerification(let completedPhotoEntity):
            return .waitForWatchingCompletedImage(imageInfo: completedPhotoEntity)
        case .canceled(let requestId):
            return .canceledBeforeRequest(requestID: requestId)
        case .error:
            throw GentiError.serverError(code: "SERVER", message: "유저상태가 error")
        }
    }
    
    func getSavedBackgroundPush() async throws -> BackgroundPushType? {
        let hasCanceledOrAwaitedRequest = try await userRepository.checkUserHasCanceledOrAwaitedRequest()
        let hasPushFromBackground = self.hasPushFromBackground()
        if hasCanceledOrAwaitedRequest || hasPushFromBackground {
            return .requestComplete
        } else if let _ = userdefaultRepository.get(forKey: .getOpenChatPushFromBackground) as? Bool {
            userdefaultRepository.remove(forKey: .getOpenChatPushFromBackground)
            return .openChat
        }
        return nil
    }
    
    func checkOpenChat() async throws -> GentiOpenChatAgreementType {
        return try await userRepository.getOpenChatInfo()
    }
    
    @MainActor
    func checkCanceledImage(requestId: Int) async throws {
        try await userRepository.checkCanceledImage(requestId: requestId)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
    }
    
    private func hasPushFromBackground() -> Bool {
        guard let hasPushFromBackground = userdefaultRepository.get(forKey: .getPushFromBackground) as? Bool else {
            return false
        }
        userdefaultRepository.remove(forKey: .getPushFromBackground)
        return hasPushFromBackground
    }
}

