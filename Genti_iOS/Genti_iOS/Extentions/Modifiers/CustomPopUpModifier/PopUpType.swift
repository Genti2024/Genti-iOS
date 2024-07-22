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
    
    /// 팝업 타입에 맞는 AnyCustomPopup 객체를 반환합니다.
    var object: AnyCustomPopup {
        switch self {
        case .selectOnboarding:
            return AnyCustomPopup(popup: SelectOnboardingPopup())
        case .rating:
            return AnyCustomPopup(popup: RatingPopup())
        }
    }
}
