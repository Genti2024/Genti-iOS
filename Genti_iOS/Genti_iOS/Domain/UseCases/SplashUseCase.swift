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
    
    func canAutoLogin() async -> Bool {
        guard checkUserAlreadySignIn() else { return false }
        if await authRepository.reissueTokenSuccess() {
            return true
        } else {
            return false
        }
    }
    
    private func checkUserAlreadySignIn() -> Bool {
        return userdefaultRepository.getUserRole() == .signInComplete
    }
}
