//
//  LoginUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation
import AuthenticationServices

protocol LoginUseCase {
    func loginWithKaKao() async throws -> LoginUserState //완
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState //완
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
    
    // 카카오로그인을 위해서는
    // api에 카카오토큰과 fcm토큰이 필요하다
    // 1. usecase에서 repository를 호출해서 하는 방식
    // 2. login메서드의 호출부가 repository를 가지고있다가 호출하는 방식
    // 결국 로그인을 하기위해서는 몇 가지 종류의 token이 필요함
    // 해당토큰을 가지고 authrepository에서 user의 로그인상태를 받아와야함
    
    // 1.authrepository가 tokenrepository를 가지고 있는방법
    // 2.usecase가 authrepository와 tokenrepository를 가지고 있는 방법
    // 1번 방식의 장점 로직이 어떻게 동작하느니를 usecase입장에선 알수있음
    // 2번 방식의 장점 내부적인 동작을 usecase가 몰라도 됨
    
    @MainActor
    func loginWithKaKao() async throws -> LoginUserState {
        let token = try await tokenRepository.getKaKaoToken()
        let fcmToken = try getFcmToken()
        return try await loginRepository.kakaoLogin(token: token, fcmToken: fcmToken)
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
