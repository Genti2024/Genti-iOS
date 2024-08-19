//
//  TokenRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKUser

struct AppleLoginToken {
    let authorizationCode: String
    let identityToken: String
}

final class TokenRepositoryImpl: TokenRepository {

    func getAppleToken(_ result: Result<ASAuthorization, Error>) throws -> AppleLoginToken {
        switch result {
        case .success(let authResults):
            return try handleAppleSuccess(authResults)
        case .failure(let error):
            try handleAppleFailure(error)
            return .init(authorizationCode: "", identityToken: "")
        }
    }
    
    func getKaKaoToken() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await loginKakaoWithApp()
        }
        return try await loginKakaoWithWeb()
    }
    
    @MainActor
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else {
                    guard let errorDescription = error?.localizedDescription else { return }
                    if errorDescription.contains("The operation couldn’t be completed") {
                        continuation.resume(throwing: GentiError.tokenError(code: "NOTCOMPLETE", message: "로그인중간에포기"))
                        return
                    }
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: errorDescription))
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오토큰을 전달받지 못했습니다"))
                    return
                }
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
    @MainActor
    private func loginKakaoWithWeb() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                guard error == nil else {
                    guard let errorDescription = error?.localizedDescription else { return }
                    if errorDescription.contains("The operation couldn’t be completed") {
                        continuation.resume(throwing: GentiError.tokenError(code: "NOTCOMPLETE", message: "로그인중간에포기"))
                        return
                    }
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: errorDescription))
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오토큰을 전달받지 못했습니다"))
                    return
                }
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
    private func handleAppleSuccess(_ authResults: ASAuthorization) throws -> AppleLoginToken {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let identityToken = try getIdentityToken(from: appleIDCredential)
            let authrizationCode = try getAuthorizationToken(from: appleIDCredential)
            return .init(authorizationCode: authrizationCode, identityToken: identityToken)
        default:
            throw GentiError.tokenError(code: "Apple Token", message: "Apple login 인증 실패")
        }
    }

    private func getIdentityToken(from appleIDCredential: ASAuthorizationAppleIDCredential) throws -> String {
        if let identityTokenData = appleIDCredential.identityToken,
           let identityToken = String(data: identityTokenData, encoding: .utf8) {
            return identityToken
        } else {
            throw GentiError.tokenError(code: "Apple Token", message: "identityToken을 찾을 수 없습니다")
        }
    }
    
    private func getAuthorizationToken(from appleIDCredential: ASAuthorizationAppleIDCredential) throws -> String {
        if let authTokenData = appleIDCredential.authorizationCode,
           let authToken = String(data: authTokenData, encoding: .utf8) {
            return authToken
        } else {
            throw GentiError.tokenError(code: "Apple Token", message: "authToken을 찾을 수 없습니다")
        }
    }

    private func handleAppleFailure(_ error: Error) throws {
        let errorDescription = error.localizedDescription
        if errorDescription.contains("The operation couldn’t be completed") {
            throw GentiError.tokenError(code: "NOTCOMPLETE", message: "로그인중간에포기")
        }
        throw GentiError.tokenError(code: "Apple Token", message: "\(error.localizedDescription)")
    }
}
