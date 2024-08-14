//
//  OnboardingStep.swift
//  Genti_iOS
//
//  Created by uiskim on 7/9/24.
//

import Foundation

enum OnboardingStep: CaseIterable {
    case first, second
    
    var setLogoWidth: CGFloat {
        switch self {
        case .first:
            return 68
        case .second:
            return 154
        }
    }
    
    var setLogoHight: CGFloat {
        switch self {
        case .first:
            return 23
        case .second:
            return 51
        }
    }
    
    var setLogoTopPadding: CGFloat {
        switch self {
        case .first:
            return 15
        case .second:
            return 26
        }
    }
    
    var setButtonTitle: String {
        switch self {
        case .first:
            return "다음으로"
        case .second:
            return "젠티하러 가기"
        }
    }
}
