//
//  SettingUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/16/24.
//

import Foundation
import Combine
import AuthenticationServices

protocol SettingUseCase {
    func logout() async throws //완
    func resign() async throws //완
}

final class SettingUseCaseImpl: NSObject, SettingUseCase {

    let tokenRepository = TokenRepositoryImpl()
    let authRepository = AuthRepositoryImpl(requestService: RequestServiceImpl())
    let userdefaultRepository = UserDefaultsRepositoryImpl()
    
    @MainActor
    func resign() async throws {
        try await authRepository.resign()
        self.initalizeForResignLocalDB()
    }
    
    @MainActor
    func logout() async throws {
        try await authRepository.logout()
        self.initalizeForResignLocalDB()
    }
    
    private func initalizeForResignLocalDB() {
        self.removeUserDefaultRelatedWithAuth()
        EventLogManager.shared.logEvent(.resign)
    }
    
    private func removeUserDefaultRelatedWithAuth() {
        userdefaultRepository.removeToken()
        userdefaultRepository.removeUserRole()
    }
}
