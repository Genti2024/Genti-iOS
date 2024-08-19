//
//  LoginViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/29/24.
//

import SwiftUI
import AuthenticationServices

@Observable
final class LoginViewModel: ViewModel {
    
    let router: Router<MainRoute>
    let loginUseCase: LoginUseCase
    
    var state: State
    
    init(loginUseCase: LoginUseCase, router: Router<MainRoute>) {
        self.loginUseCase = loginUseCase
        self.router = router
        self.state = .init()
    }
    
    struct State {
        var showAlert: AlertType? = nil
    }
    
    enum Input {
        case kakaoLoginTap
        case appleLoginTap(Result<ASAuthorization, any Error>)
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .kakaoLoginTap:
            Task { await kakaoLogin() }
        case .appleLoginTap(let result):
            Task { await appleLogin(result) }
        }
    }
    
    @MainActor
    func kakaoLogin() async {
        do {
            let result = try await loginUseCase.loginWithKaKao()
            push(from: result)
        } catch(let error) {
            handleError(error)
        }
    }
    
    @MainActor
    func appleLogin(_ result: Result<ASAuthorization, any Error>) async {
        do {
            let result = try await loginUseCase.loginWithApple(result)
            try await Task.sleep(nanoseconds: 300000000)
            push(from: result)
        } catch(let error) {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        guard let error = error as? GentiError else {
            state.showAlert = .reportUnknownedError(error: error, action: nil)
            return
        }
        if error.code == "NOTCOMPLETE" { return }
        state.showAlert = .reportGentiError(error: error, action: nil)
    }
    
    private func push(from loginState: LoginUserState) {
        switch loginState {
        case .signInComplete:
            self.router.routeTo(.mainTab)
        case .signInNotComplete:
            self.router.routeTo(.signIn)
        }
    }
}
