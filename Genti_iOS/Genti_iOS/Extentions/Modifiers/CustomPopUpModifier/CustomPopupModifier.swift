//
//  CustomPopupModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

/// CustomPopupModifier는 뷰에 팝업을 추가하는 뷰 모디파이어입니다.
struct CustomPopupModifier: ViewModifier {
    var isPresented: Binding<Bool>
    var customPopup: AnyCustomPopup
    
    init(isPresented: Binding<Bool>, popupType: PopupType) {
        self.isPresented = isPresented
        self.customPopup = popupType.object
    }
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: isPresented, view: { customPopup.contentView }, customize: customPopup.customize)
    }
}

/// View 확장을 통해 쉽게 팝업을 추가할 수 있는 메서드를 제공합니다.
extension View {
    func addCustomPopup(isPresented: Binding<Bool>, popupType: PopupType) -> some View {
        modifier(CustomPopupModifier(isPresented: isPresented, popupType: popupType))
    }
}
