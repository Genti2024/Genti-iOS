//
//  AddXmarkModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct AddXmarkModifier: ViewModifier {
    var topPadding: CGFloat? = nil
    var bottomPadding: CGFloat? = nil
    var leadingPadding: CGFloat? = nil
    var trailingPadding: CGFloat? = nil
    var xmarkTap: (()->Void)?
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                Image(.xmarkEmpty)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29, height: 29)
                    .padding(7)
                    .onTapGesture {
                        xmarkTap?()
                    }
                    .padding(.bottom, bottomPadding)
                    .padding(.top, topPadding)
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
            }
    }
}

extension View {
    func addXmark(top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, action xmarkTap: (()->Void)? = nil) -> some View {
        return modifier(AddXmarkModifier(topPadding: top, bottomPadding: bottom, leadingPadding: leading, trailingPadding: trailing, xmarkTap: xmarkTap))
    }
}
