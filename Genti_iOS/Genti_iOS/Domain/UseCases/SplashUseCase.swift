//
//  SplashUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/31/24.
//

import SwiftUI

protocol SplashUseCase {
    func canAutoLogin() async -> Bool
}

final class SplashUseCaseImpl: SplashUseCase {
  
    var authRepository: AuthRepository
    var userdefaultRepository: UserDefaultsRepository
    
    init(authRepository: AuthRepository, userdefaultRepository: UserDefaultsRepository) {
        self.authRepository = authRepository
        self.userdefaultRepository = userdefaultRepository
    }
    
    @MainActor
    func canAutoLogin() async -> Bool {
        guard let userRole = userdefaultRepository.getUserRole() else { return false }
        switch userRole {
        case .signInComplete:
            let token = userdefaultRepository.getToken()
            guard let accessToken = token.accessToken, let refreshToken = token.refreshToken else { return false }
            do {
                let reissuedToken = try await authRepository.reissueToken(token: .init(accessToken: accessToken, refreshToken: refreshToken))
                userdefaultRepository.setToken(token: reissuedToken)
                return true
            } catch {
                return false
            }
        case .signInNotComplete:
            return false
        }
    }
}
