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
    }
}