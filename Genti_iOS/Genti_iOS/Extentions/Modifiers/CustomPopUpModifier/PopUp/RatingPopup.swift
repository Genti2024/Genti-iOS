//
//  RatingPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

/// RatingPopup 구조체는 CustomPopup 프로토콜을 준수하며, 특정 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
struct RatingPopup: CustomPopup {
    /// contentView는 특정 팝업 콘텐츠를 나타냅니다.
    var contentView: some View {
        RatingAlertView(viewModel: RatingAlertViewModel(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())))
    }
    
    /// customize는 팝업의 커스터마이징 옵션을 정의합니다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}
