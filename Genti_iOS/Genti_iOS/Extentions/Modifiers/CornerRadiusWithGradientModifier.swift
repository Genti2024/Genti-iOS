//
//  CornerRadiusWithGradientModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct CornerRadiusWithGradientModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(LinearGradient(colors: [.gentiGreen, .gentiGreen.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            )
    }
}

extension View {
    func cornerRadiusWithGradient() -> some View {
        return modifier(CornerRadiusWithGradientModifier())
    }
}
