//
//  AuthRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {

    let requestService: RequestService
    
    init(requestService: RequestService) {
        self.requestService = requestService
    }
    
    func login(token: String, type: GentiSocialLoginType) async throws -> SocialLoginEntity {
        let dto: SocialLoginDTO = try await requestService.fetchResponse(for: AuthRouter.login(token: token, type: type))
        return dto.toEntity
    }
    
    func signIn(sex: String, birthYear: String) async throws -> SignInUserEntity {
        let dto: SignInUserDTO = try await requestService.fetchResponse(for: AuthRouter.signIn(sex: sex, birthData: birthYear))
        guard let entity = dto.toEntitiy() else {
            throw GentiError.clientError(code: "회원가입유저", message: "데이터변환오류")
        }
        return entity
    }
    
    func reissueToken(token: GentiTokenEntity) async throws -> GentiTokenEntity {
        let dto: ReissueTokenDTO = try await requestService.fetchResponse(for: AuthRouter.reissueToken(token: token))
        return GentiTokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
    
    func logout() async throws {
        try await requestService.fetchResponse(for: AuthRouter.logout)
    }
    
    func resignKakao() async throws {
        try await requestService.fetchResponse(for: AuthRouter.resignKakao)
    }
    
    func resignApple(authToken: String) async throws {
        try await requestService.fetchResponse(for: AuthRouter.resignAppleTest(authorizationToken: authToken))
    }
}
