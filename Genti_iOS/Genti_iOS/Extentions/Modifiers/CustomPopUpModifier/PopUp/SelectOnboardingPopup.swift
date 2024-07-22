//
//  SelectOnboardingPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

/// SelectOnboardingPopup 구조체는 CustomPopup 프로토콜을 준수하며, 특정 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
struct SelectOnboardingPopup: CustomPopup {
    /// contentView는 특정 팝업 콘텐츠를 나타냅니다.
    var contentView: some View {
        Image("selectOnboarding")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 16)
    }
    
    /// customize는 팝업의 커스터마이징 옵션을 정의합니다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTapOutside(true)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}
