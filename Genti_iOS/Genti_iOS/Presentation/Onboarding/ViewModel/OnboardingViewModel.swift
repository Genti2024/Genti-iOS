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
                state.step = .second
            case .second:
                self.router.dismissSheet()
            }
        case .xmarkTap:
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
    
    var setLogoWidth: CGFloat {
        switch state.step {
        case .first:
            return 68
        case .second:
            return 154
        }
    }
    
    var setLogoHight: CGFloat {
        switch state.step {
        case .first:
            return 23
        case .second:
            return 51
        }
    }
    
    var setLogoTopPadding: CGFloat {
        switch state.step {
        case .first:
            return 15
        case .second:
            return 26
        }
    }
    
    var setButtonTitle: String {
        switch state.step {
        case .first:
            return "다음으로"
        case .second:
            return "젠티하러 가기"
        }
    }
    
    func setPageControl(from step: OnboardingStep) -> Color {
        if step == state.step {
            return .gentiGreen
        }
        return .gray5
    }
    
    var isFirstStep: Bool {
        return state.step == .first
    }
}
