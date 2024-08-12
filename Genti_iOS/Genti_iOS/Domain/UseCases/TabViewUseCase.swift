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
    func hasCanceledCase() async throws -> UserRequestCancelState
    func checkBackgroundNotification() -> Bool
}

final class TabViewUseCaseImpl: TabViewUseCase {

    
    
    let userRepository: UserRepository
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserState() async throws -> UserState {
        return try await userRepository.getUserState()
    }
    
    func checkBackgroundNotification() -> Bool {
        guard let hasBackgroundNotification = userdefaultRepository.get(forKey: .showImage) as? Bool else { return false }
        userdefaultRepository.remove(forKey: .showImage)
        return hasBackgroundNotification
    }
    
    @MainActor
    func checkCanceledImage(requestId: Int) async throws {
        try await userRepository.checkCanceledImage(requestId: requestId)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
    }
    
    func hasCanceledCase() async throws -> UserRequestCancelState {
        let userState = try await userRepository.getUserState()
        switch userState {
        case .canceled(let requestId):
            return .init(canceled: true, requestId: requestId)
        default:
            return .init(canceled: false, requestId: nil)
        }
    }
}

