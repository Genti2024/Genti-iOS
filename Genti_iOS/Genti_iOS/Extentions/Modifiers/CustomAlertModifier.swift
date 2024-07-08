//
//  CustomAlertModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 6/25/24.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var alertType: AlertType?
    
    var alertData: Alert? {
        guard let alertType = alertType else { return nil }
        return alertType.data
    }
    
    func body(content: Content) -> some View {
        content
            .alert(alertData?.title ?? "", isPresented: Binding<Bool>(
                get: { alertType != nil },
                set: { alertType = $0 ? alertType : nil }
            ), presenting: alertData) { data in
                ForEach(data.actions) { action in
                    Button(role: action.style, action: action.action ?? {}) {
                        Text(action.title)
                    }
                }
                if let text = data.textFieldText {
                    TextField("", text: text)
                }
            } message: { data in
                if let message = data.message {
                    Text(message)
                }
            }
    }
}

extension View {
    func customAlert(alertType: Binding<AlertType?>) -> some View {
        self.modifier(CustomAlertModifier(alertType: alertType))
    }
}
