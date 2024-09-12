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

    struct State {
        var showAlert: AlertType? = nil
    }
    
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
        if await self.checkAndUpdateIfNeeded() {
            self.state.showAlert = .update(action: {
                AppStoreCheck().openAppStore()
            })
        } else {
            if await splashUseCase.canAutoLogin() {
                router.routeTo(.login)
                router.routeTo(.mainTab)
            } else {
                router.routeTo(.login)
            }
        }
    }
}

extension SplashViewModel {
    func checkAndUpdateIfNeeded() async -> Bool {
        return await withCheckedContinuation { continuation in
            AppStoreCheck().latestVersion { marketingVersion in
                DispatchQueue.main.async {
                    guard let marketingVersion = marketingVersion else {
                        continuation.resume(returning: false)
                        return
                    }

                    let currentProjectVersion = AppStoreCheck.appVersion ?? ""
                    let splitMarketingVersion = marketingVersion.split(separator: ".").map { $0 }
                    let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map { $0 }
                    if splitCurrentProjectVersion.count > 0 && splitMarketingVersion.count > 0 {
                        if splitCurrentProjectVersion[0] < splitMarketingVersion[0] || splitCurrentProjectVersion[1] < splitMarketingVersion[1] {
                            continuation.resume(returning: true)
                        } else {
                            continuation.resume(returning: false)
                        }
                    }
                }
            }
        }
    }
}
