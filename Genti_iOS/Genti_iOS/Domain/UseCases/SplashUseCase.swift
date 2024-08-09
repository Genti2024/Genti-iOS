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
        guard let userRole = userdefaultRepository.getUserRole() else {
            print(#fileID, #function, #line, "- userrole이 없음")
            return false
        }
        
        switch userRole {
        case .complete:
            print(#fileID, #function, #line, "- userrole이 회원가입까지 완료된 상태")
            let token = userdefaultRepository.getToken()
            guard let accessToken = token.accessToken, let refreshToken = token.refreshToken else {
                print(#fileID, #function, #line, "- userrole은 있는데 token은 nil임")
                return false
            }
            do {
                let reissuedToken = try await authRepository.reissueToken(token: .init(accessToken: accessToken, refreshToken: refreshToken))
                userdefaultRepository.setToken(token: reissuedToken)
                return true
            } catch {
                print(#fileID, #function, #line, "- 스플래시에서 오류발생")
                return false
            }
        case .notComplete:
            print(#fileID, #function, #line, "- userrole이 회원가입이 완료된 상태가 아님")
            return false
        }
    }
}
