//
//  SplashViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/31/24.
//

import SwiftUI

@Observable
final class SplashViewModel: ViewModel {
    var state: State
    
    var router: Router<MainRoute>
    var splashUseCase: SplashUseCase
    
    init(router: Router<MainRoute>, splashUseCase: SplashUseCase) {
        self.router = router
        self.splashUseCase = splashUseCase
        self.state = .init()
    }

    struct State {}
    
    enum Input {
        case splashAnimationFinished
    }
    
    enum Outcome {
        case authLogin(Bool)
    }
    
    func sendAction(_ input: Input) {}
    
    @discardableResult
    func execute(_ action: Input) -> Task<Void, Never> {
        switch action {
        case .splashAnimationFinished:
            return Task {
                let canAutoLogin = await splashUseCase.canAutoLogin()
                await perform(from: .authLogin(canAutoLogin))
            }
        }
    }
    
    @MainActor
    func perform(from outcome: Outcome) {
        switch outcome {
        case .authLogin(let canAutoLogin):
            if canAutoLogin {
                router.routeTo(.login)
                router.routeTo(.mainTab)
            } else {
                router.routeTo(.login)
            }
        }
    }
}
