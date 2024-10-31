//
//  GeneratorNavigationButton.swift
//  Genti
//
//  Created by uiskim on 5/5/24.
//

import SwiftUI

struct GentiPrimaryButton: View {
    
    let action: () -> Void
    let isActive: Bool
    let title: String
    
    init(title: String, isActive: Bool, _ action: @escaping () -> Void) {
        self.action = action
        self.isActive = isActive
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .pretendard(.subtitle2_16_bold)
            .foregroundStyle(.black)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(isActive ? .gentiGreenNew : .gentiDisabled)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 16)
            .asButton(.press) {
                action()
            }
            .disabled(!isActive)
    }
}

#Preview {
    VStack(spacing: 10) {
        GentiPrimaryButton(title: "테스트", isActive: true) {}
        GentiPrimaryButton(title: "테스트", isActive: false) {}
    }
}
