//
//  CustomPopupModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

struct CustomPopupModifier: ViewModifier {
    var isPresented: Binding<Bool>
    var customPopup: any CustomPopup
    
    init(isPresented: Binding<Bool>, popupType: PopupType) {
        self.isPresented = isPresented
        self.customPopup = popupType.object
    }
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: isPresented, view: { AnyView(customPopup.contentView) }, customize: customPopup.customize)
    }
}

extension View {
    func addCustomPopup(isPresented: Binding<Bool>, popupType: PopupType) -> some View {
        modifier(CustomPopupModifier(isPresented: isPresented, popupType: popupType))
    }
}
