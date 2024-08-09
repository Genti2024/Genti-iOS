//
//  SignInUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/8/24.
//

import Foundation

protocol SignInUseCase {
    func signIn(gender: Gender?, birthYear: Int) async throws
}

final class SignInUseCaseImpl: SignInUseCase {
    
    let authRepository: AuthRepository
    let userdefaultRepository: UserDefaultsRepository
    
    init(authRepository: AuthRepository, userdefaultRepository: UserDefaultsRepository) {
        self.authRepository = authRepository
        self.userdefaultRepository = userdefaultRepository
    }
    
    @MainActor
    func signIn(gender: Gender?, birthYear: Int) async throws {
        guard let sex = gender?.description  else { return }
        try await authRepository.signIn(sex: sex, birthYear: String(describing: birthYear))
        userdefaultRepository.setUserRole(userRole: .complete)
    }
}
