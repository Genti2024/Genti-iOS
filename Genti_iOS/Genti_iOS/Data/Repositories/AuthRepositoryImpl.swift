//
//  AuthRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    let userdefaultsRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    let requestService: RequestService
    
    init(requestService: RequestService) {
        self.requestService = requestService
    }
    
    func resign() async throws {
        try await requestService.fetchResponse(for: AuthRouter.resign)
    }
    
    func kakaoLogin(token: String, fcmToken: String) async throws -> SocialLoginEntity {
        let dto: SocialLoginDTO = try await requestService.fetchResponse(for: AuthRouter.kakaoLogin(token: token, fcmToken: fcmToken))
        return dto.toEntity
    }
    
    func appleLogin(authorizationCode: String, identityToken: String, fcmToken: String) async throws -> SocialLoginEntity {
        let dto: SocialLoginDTO = try await requestService.fetchResponse(for: AuthRouter.appleLogin(authorizationCode: authorizationCode, identityToken: identityToken, fcmToken: fcmToken))
        return dto.toEntity
    }
    
    func signIn(sex: String, birthYear: String) async throws -> SignInUserEntity {
        let dto: SignInUserDTO = try await requestService.fetchResponse(for: AuthRouter.signIn(sex: sex, birthYear: birthYear))
        guard let entity = dto.toEntitiy() else {
            throw GentiError.clientError(code: "회원가입유저", message: "데이터변환오류")
        }
        return entity
    }
    
    func reissueTokenSuccess() async -> Bool {
        do {
            let token = userdefaultsRepository.getToken()
            guard let accessToken = token.accessToken, let refreshToken = token.refreshToken, let fcmToken = token.fcmToken else { return false }
            let dto: ReissueTokenDTO = try await requestService.fetchResponseNonRetry(for: AuthRouter.reissueToken(token: .init(accessToken: accessToken, refreshToken: refreshToken, fcmToken: fcmToken)))
            userdefaultsRepository.set(to: dto.accessToken, forKey: .accessToken)
            userdefaultsRepository.set(to: dto.refreshToken, forKey: .refreshToken)
            return true
        } catch {
            return false
        }
    }
    
    func logout() async throws {
        try await requestService.fetchResponse(for: AuthRouter.logout)
    }
    
}
