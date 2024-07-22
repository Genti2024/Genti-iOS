//
//  AnyCustomPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

/// AnyCustomPopup 구조체는 다양한 팝업 타입을 AnyView로 감싸서 다룰 수 있게 합니다.
struct AnyCustomPopup {
    var contentView: AnyView
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters
    
    init<PopupObject: CustomPopup>(popup: PopupObject) {
        self.contentView = AnyView(popup.contentView)
        self.customize = popup.customize
    }
}
