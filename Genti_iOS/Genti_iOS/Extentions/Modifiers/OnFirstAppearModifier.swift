//
//  OnFirstAppearModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true

    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime = false
                perform()
            }
        }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(perform: perform))
    }
}
