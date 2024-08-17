//
//  AuthRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

protocol AuthRepository {
    func kakaoLogin(token: String) async throws -> SocialLoginEntity
    func appleLogin(authorizationCode: String, identityToken: String) async throws -> SocialLoginEntity
    func reissueToken(token: GentiTokenEntity) async throws -> GentiTokenEntity
    func signIn(sex: String, birthYear: String) async throws -> SignInUserEntity
    func logout() async throws
    func resign() async throws
}
