//
//  LoginUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation
import AuthenticationServices

protocol LoginUseCase {
    func loginWithKaKao() async throws -> LoginUserState
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState
}

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
        let fcmToken = try getFcmToken()
        let result = try await loginRepository.kakaoLogin(token: token, fcmToken: fcmToken)
        self.setUserdefaults(from: result, loginType: .kakao)
        return result.userStatus
    }
    
    @MainActor
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState {
        let token = try tokenRepository.getAppleToken(result)
        let fcmToken = try getFcmToken()
        let result = try await loginRepository.appleLogin(authorizationCode: token.authorizationCode, identityToken: token.identityToken, fcmToken: fcmToken)
        self.setUserdefaults(from: result, loginType: .apple)
        return result.userStatus
    }
    
    private func setUserdefaults(from result: SocialLoginEntity, loginType: GentiSocialLoginType) {
        self.userdefaultRepository.setLoginType(type: loginType)
        self.userdefaultRepository.setUserRole(userRole: result.userStatus)
        self.userdefaultRepository.setAccessToken(token: result.accessToken)
        self.userdefaultRepository.setRefreshToken(token: result.refreshToken)
    }
    
    private func getFcmToken() throws -> String {
        guard let fcmToken = userdefaultRepository.get(forKey: .fcmToken) as? String else {
            throw GentiError.tokenError(code: "FCMTOKEN", message: "fcmToken이 local DB에 없습니다")
        }
        return fcmToken
    }
}
