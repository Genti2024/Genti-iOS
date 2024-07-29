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
    let loginUseCase: LoginUseCase
    
    let router: Router<MainRoute>
    
    var state: State
    
    func sendAction(_ input: Input) {
        switch input {
        case .kakaoLoginTap:
            Task {
                do {
                    let result = try await loginUseCase.loginWithKaKao()
                    print(result.accessToken)
                    print(result.refreshToken)
                    print(result.userStatus)
                    await MainActor.run {
                        router.routeTo(.signIn)
                    }
                } catch(let error) {
                    print(error.localizedDescription)
                }
            }
            
        case .appleLoginTap(let result):
            print(#fileID, #function, #line, "- dd")
//            loginUseCase.loginWithApple(result)
        }
    }
    
    struct State {
        
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
}
