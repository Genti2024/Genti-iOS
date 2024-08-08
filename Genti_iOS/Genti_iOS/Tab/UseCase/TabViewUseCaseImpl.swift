//
//  TabViewUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 8/2/24.
//

import Foundation

final class TabViewUseCaseImpl: TabViewUseCase {
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserState() async throws -> UserState {
        return try await userRepository.getUserState()
    }
    
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

struct UserRequestCancelState {
    let canceled: Bool
    let requestId: Int?
}
