//
//  TabViewUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/2/24.
//

import Foundation

protocol TabViewUseCase {
    func getUserState() async throws -> UserState
    func checkCanceledImage(requestId: Int) async throws
    func getSavedBackgroundPush() async throws -> BackgroundPushType?
    func checkOpenChat() async throws -> GentiOpenChatAgreementType
}

final class TabViewUseCaseImpl: TabViewUseCase {

    let userRepository: UserRepository
    let userdefaultRepository: UserDefaultsRepository
    
    init(userRepository: UserRepository, userdefaultRepository: UserDefaultsRepository) {
        self.userRepository = userRepository
        self.userdefaultRepository = userdefaultRepository
    }
    
    func getUserState() async throws -> UserState {
        return try await userRepository.getUserState()
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

