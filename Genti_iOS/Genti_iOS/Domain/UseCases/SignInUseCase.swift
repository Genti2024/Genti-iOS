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
        let signInEntity = try await authRepository.signIn(sex: sex, birthYear: String(describing: birthYear))
        self.setEvent(signInEntity)
        self.setUserDefaults(signInEntity)
    }
    
    private func setEvent(_ signInEntity: SignInUserEntity) {
        EventLogManager.shared.logEvent(.completeInfoget)
        EventLogManager.shared.logEvent(.singIn(type: signInEntity.socialLoginType))
        EventLogManager.shared.addUserProperty(to: .userEmail(email: signInEntity.email))
        EventLogManager.shared.addUserProperty(to: .userLoginType(loginType: signInEntity.socialLoginType))
        EventLogManager.shared.addUserProperty(to: .userNickname(nickname: signInEntity.nickname))
        EventLogManager.shared.addUserProperty(to: .userBirthYear(birthYear: signInEntity.birthYear))
        EventLogManager.shared.addUserProperty(to: .userGender(gender: signInEntity.gender))
    }
    
    private func setUserDefaults(_ signInEntity: SignInUserEntity) {
        userdefaultRepository.setLoginType(type: signInEntity.socialLoginType)
        userdefaultRepository.setUserRole(userRole: .complete)
    }
}
