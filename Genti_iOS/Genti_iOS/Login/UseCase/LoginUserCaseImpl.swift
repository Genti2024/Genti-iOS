//
//  LoginUserCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation
import AuthenticationServices

final class LoginUserCaseImpl: LoginUseCase {

    let tokenRepository: TokenRepository
    let loginRepository: AuthRepository
    let userdefaultRepository: UserDefaultsRepository
    
    init(tokenRepository: TokenRepository, loginRepository: AuthRepository, userdefaultRepository: UserDefaultsRepository) {
        self.tokenRepository = tokenRepository
        self.loginRepository = loginRepository
        self.userdefaultRepository = userdefaultRepository
    }
    
    @MainActor
    func loginWithKaKao() async throws -> LoginUserState {
        let token = try await tokenRepository.getKaKaoToken()
        let result = try await loginRepository.login(token: token, type: .kakao) 
        self.userdefaultRepository.setUserRole(userRole: result.userStatus)
        self.userdefaultRepository.setToken(token: .init(accessToken: result.accessToken, refreshToken: result.refreshToken))
        return result.userStatus
    }
    
    @MainActor
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState {
        let token = try tokenRepository.getAppleToken(result)
        let result = try await loginRepository.login(token: token, type: .apple)
        self.userdefaultRepository.setUserRole(userRole: result.userStatus)
        self.userdefaultRepository.setToken(token: .init(accessToken: result.accessToken, refreshToken: result.refreshToken))
        return result.userStatus
    }

}
