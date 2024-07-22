//
//  GeneratorNavigationButton.swift
//  Genti
//
//  Created by uiskim on 5/5/24.
//

import SwiftUI

struct GeneratorNavigationButton: View {
    
    let action: () -> Void
    let isActive: Bool
    let title: String
    
    init(isActive: Bool, title: String = "다음으로", _ action: @escaping () -> Void) {
        self.action = action
        self.isActive = isActive
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .pretendard(.headline1)
            .foregroundStyle(isActive ? .black : .white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(isActive ? .gray5 : .green1)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 28)
            .asButton(.press) {
                action()
            }
            .disabled(isActive)
    }
}

#Preview {
    VStack(spacing: 10) {
        GeneratorNavigationButton(isActive: true) {}
        GeneratorNavigationButton(isActive: true) {}
        GeneratorNavigationButton(isActive: false) {}
        GeneratorNavigationButton(isActive: true, title: "테스트") {}
        GeneratorNavigationButton(isActive: false, title: "테스트") {}
    }

}
