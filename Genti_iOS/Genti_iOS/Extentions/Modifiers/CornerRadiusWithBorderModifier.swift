//
//  CornerRadiusWithBorderModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct CornerRadiusWithBorderModifier<S: ShapeStyle>: ViewModifier {
    let style: S
    let radius: CGFloat
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(style, lineWidth: lineWidth)
            )
    }
}

extension View {
    func cornerRadiusWithBorder<S: ShapeStyle>(style: S, radius: CGFloat, lineWidth: CGFloat) -> some View {
        return modifier(CornerRadiusWithBorderModifier(style: style, radius: radius, lineWidth: lineWidth))
    }
}
