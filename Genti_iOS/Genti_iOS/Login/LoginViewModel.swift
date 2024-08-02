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
    
    struct State {
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
    }
    
    enum Input {
        case kakaoLoginTap
        case appleLoginTap(Result<ASAuthorization, any Error>)
    }
    
    init(loginUseCase: LoginUseCase, router: Router<MainRoute>) {
        self.loginUseCase = loginUseCase
        self.router = router
        self.state = .init()
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
            state.isLoading = true
            let result = try await loginUseCase.loginWithKaKao()
            state.isLoading = false
            switch result {
            case .complete:
                self.router.routeTo(.mainTab)
            case .notComplete:
                self.router.routeTo(.signIn)
            }
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }
    
    @MainActor
    func appleLogin(_ result: Result<ASAuthorization, any Error>) async {
        do {
            let result = try await loginUseCase.loginWithApple(result)
            switch result {
            case .complete:
                self.router.routeTo(.mainTab)
            case .notComplete:
                self.router.routeTo(.signIn)
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
