//
//  OnboardingViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/9/24.
//

import SwiftUI

@Observable
final class OnboardingViewModel: ViewModel {
    var state: State
    var router: Router<MainRoute>

    init(router: Router<MainRoute>) {
        self.router = router
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .nextButtonTap:
            switch state.step {
            case .first:
                EventLogManager.shared.logEvent(.clickButton(page: .onboarding1, buttonName: "next"))
                state.step = .second
            case .second:
                state.step = .third
            case .third:
                EventLogManager.shared.logEvent(.clickButton(page: .onboarding2, buttonName: "gogenti"))
                self.router.dismissSheet()
            }
        case .xmarkTap:
            EventLogManager.shared.logEvent(.clickButton(page: .onboarding1, buttonName: "exit"))
            self.router.dismissSheet()
        }
    }
    
    struct State {
        var step: OnboardingStep = .first
        var onboardingImage: [String] = ["Onboarding11", "Onboarding12", "Onboarding13"]
    }
    
    enum Input {
        case nextButtonTap
        case xmarkTap
    }
    
    func setPageControl(from step: OnboardingStep) -> Color {
        if step == state.step {
            return .gentiGreenNew
        }
        return .white.opacity(0.3)
    }
    
    func set(from step: OnboardingStep) -> CGFloat {
        if step == state.step {
            return 8
        }
        return 6
    }
    
    var isFirstStep: Bool {
        return state.step == .first
    }
}
