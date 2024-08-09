//
//  ShadowModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import SwiftUI

enum GentiShadowType {
    case soft
    case strong
    
    var color: Color {
        switch self {
        case .soft:
            return .black.opacity(0.03)
        case .strong:
            return .black.opacity(0.09)
        }
    }
    
    var blur: CGFloat {
        switch self {
        case .soft:
            return 13
        case .strong:
            return 17
        }
    }
}

struct ShadowModifier: ViewModifier {
    let type: GentiShadowType
    
    func body(content: Content) -> some View {
        content
            .shadow(color: type.color, radius: type.blur)
    }
}

extension View {
    /// genti design system의 shadow를 적용합니다
    /// - Parameter type: soft: 3%, strong: 9%
    /// - Returns: 적용된 뷰
    func shadow(type: GentiShadowType) -> some View {
        modifier(ShadowModifier(type: type))
    }
}
