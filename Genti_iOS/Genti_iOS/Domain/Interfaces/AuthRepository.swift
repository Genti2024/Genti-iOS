//
//  AuthRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

protocol AuthRepository {
    func kakaoLogin(token: String, fcmToken: String) async throws -> SocialLoginEntity
    func appleLogin(authorizationCode: String, identityToken: String, fcmToken: String) async throws -> SocialLoginEntity
    func reissueTokenSuccess() async -> Bool
    func signIn(sex: String, birthYear: String) async throws -> SignInUserEntity
    func logout() async throws
    func resign() async throws
}
