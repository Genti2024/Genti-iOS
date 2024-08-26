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
    func showCompleteStateWhenUserInitalAccess() async throws -> Bool
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
    
    func showCompleteStateWhenUserInitalAccess() async throws -> Bool {
        let hasCanceledOrAwaitedRequest = try await userRepository.checkUserHasCanceledOrAwaitedRequest()
        let hasPushFromBackground = self.hasPushFromBackground()
        return hasCanceledOrAwaitedRequest && hasPushFromBackground
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

