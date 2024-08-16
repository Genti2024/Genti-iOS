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
    var appleResignCompleteSubject: PassthroughSubject<Void, Never> { get set }
    var kakaoResignCompleteSubject: PassthroughSubject<Void, Never> { get set }
    var isLoading: PassthroughSubject<Bool, Never> { get set }
    var errorSubject: PassthroughSubject<GentiError, Never> { get set }
    func logout() async throws
    func resign() async throws
    func performSignIn()
}

final class SettingUseCaseImpl: NSObject, SettingUseCase {

    let tokenRepository = TokenRepositoryImpl()
    let authRepository = AuthRepositoryImpl(requestService: RequestServiceImpl())
    let userdefaultRepository = UserDefaultsRepositoryImpl()
    
    var appleResignCompleteSubject = PassthroughSubject<Void, Never>()
    var kakaoResignCompleteSubject = PassthroughSubject<Void, Never>()
    var errorSubject = PassthroughSubject<GentiError, Never>()
    var isLoading = PassthroughSubject<Bool, Never>()
    
    @MainActor
    func resign() async throws {
        guard let loginType = userdefaultRepository.getLoginType() else { throw GentiError.clientError(code: "로그인타입", message: "로그인이 안된 유저입니다")}
        switch loginType {
        case .kakao:
            self.isLoading.send(true)
            try await authRepository.resignKakao()
            self.initalizeForResignKakaoInLocalDB()
            self.isLoading.send(false)
        case .apple:
            performSignIn()
        }
    }
    
    @MainActor
    func logout() async throws {
        try await authRepository.logout()
        self.removeUserDefaultRelatedWithAuth()
        EventLogManager.shared.logEvent(.logout)
    }
    
    
    func performSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @MainActor
    private func resignAppleLogin(from credential: ASAuthorizationAppleIDCredential) async {
        do {
            let authToken = try tokenRepository.getAppleAuthToken(credential)
            try await authRepository.resignApple(authToken: authToken)
            self.initalizeForResignAppleInLocalDB()
        } catch(let error) {
            self.errorSubject.send(.clientError(code: "애플탈퇴클라실패", message: error.localizedDescription))
        }
    }
    
    private func initalizeForResignKakaoInLocalDB() {
        self.removeUserDefaultRelatedWithAuth()
        EventLogManager.shared.logEvent(.resign)
        kakaoResignCompleteSubject.send(())
    }
    
    private func initalizeForResignAppleInLocalDB() {
        self.removeUserDefaultRelatedWithAuth()
        EventLogManager.shared.logEvent(.resign)
        self.appleResignCompleteSubject.send(())
    }
    
    private func removeUserDefaultRelatedWithAuth() {
        userdefaultRepository.removeToken()
        userdefaultRepository.removeUserRole()
    }
}

extension SettingUseCaseImpl: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            Task { await resignAppleLogin(from: appleIDCredential) }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
