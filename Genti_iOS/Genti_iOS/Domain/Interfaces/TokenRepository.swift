//
//  TokenRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation
import AuthenticationServices

protocol TokenRepository {
    func getAppleToken(_ result: Result<ASAuthorization, Error>) throws -> AppleLoginToken
    func getKaKaoToken() async throws -> String
}
