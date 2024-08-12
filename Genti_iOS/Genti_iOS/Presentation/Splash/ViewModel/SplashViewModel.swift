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
    
    func sendAction(_ input: Input) {
        switch input {
        case .splashAnimationFinished:
            Task { await autoLogin() }
        }
    }
    
    @MainActor
    func autoLogin() async {
        if await splashUseCase.canAutoLogin() {
            router.routeTo(.login)
            router.routeTo(.mainTab)
        } else {
            router.routeTo(.login)
        }
    }
}
