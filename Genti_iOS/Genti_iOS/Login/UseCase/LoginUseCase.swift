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
