//
//  AddXmarkModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct AddXmarkModifier: ViewModifier {
    var xmarkTap: (()->Void)?
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                Image(.xmarkEmpty)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29, height: 29)
                    .padding(28)
                    .background(.red)
                    .onTapGesture {
                        xmarkTap?()
                    }
            }
    }
}

extension View {
    func addXmark(action xmarkTap: (()->Void)? = nil) -> some View {
        return modifier(AddXmarkModifier(xmarkTap: xmarkTap))
    }
}
