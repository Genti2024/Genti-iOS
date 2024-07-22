//
//  PopUpType.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import Foundation

/// PopupType 열거형은 다양한 팝업 타입을 정의하고, 각 타입에 맞는 팝업 객체를 생성합니다.
enum PopupType {
    case selectOnboarding
    case rating

    var object: any CustomPopup {
        switch self {
        case .selectOnboarding:
            return SelectOnboardingPopup()
        case .rating:
            return RatingPopup()
        }
    }
}
