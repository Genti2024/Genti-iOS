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
    
    func signIn(sex: String, birthYear: String) async throws {
        return try await requestService.fetchResponse(for: AuthRouter.signIn(sex: sex, birthData: birthYear))
    }
    
    func reissueToken(token: GentiTokenEntity) async throws -> GentiTokenEntity {
        let dto: ReissueTokenDTO = try await requestService.fetchResponse(for: AuthRouter.reissueToken(token: token))
        return GentiTokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}
