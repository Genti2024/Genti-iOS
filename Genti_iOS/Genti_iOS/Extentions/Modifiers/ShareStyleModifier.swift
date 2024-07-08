//
//  ShareStyleModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

struct ShareStyleModifier: ViewModifier {
    var disable: Bool
    
    func body(content: Content) -> some View {
        content
            .pretendard(.headline1)
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(disable ? .gray4 : .gentiGreen)
            .overlay(alignment: .leading) {
                Image("Share")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .padding(.leading, 20)
            }
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 30)
    }
}

extension Text {
    func shareStyle(disable: Bool) -> some View {
        modifier(ShareStyleModifier(disable: disable))
    }
}
