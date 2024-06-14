//
//  TextEditorLimitLength.swift
//  Genti
//
//  Created by uiskim on 5/5/24.
//

import SwiftUI

struct LimitLengthModifier: ViewModifier {
    @Binding var text: String
    let limit: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { old, new in
                if new.count > limit {
                    text = old
                }
            }
    }
}

extension TextEditor {
    func limit(
        text: Binding<String>,
        limit: Int
    ) -> some View {
        modifier(LimitLengthModifier(
            text: text,
            limit: limit
        ))
    }
}
