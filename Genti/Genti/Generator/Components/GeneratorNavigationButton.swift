//
//  GeneratorNavigationButton.swift
//  Genti
//
//  Created by uiskim on 5/5/24.
//

import SwiftUI

struct GeneratorNavigationButton<Content>: View where Content: View {
    
    let destination: () -> Content
    let isActive: Bool
    let title: String
    
    init(isActive: Bool, title: String = "다음으로", @ViewBuilder _ destination: @escaping () -> Content) {
        self.destination = destination
        self.isActive = isActive
        self.title = title
    }
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            Text(title)
                .pretendard(.headline1)
                .foregroundStyle(isActive ? .black : .white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(isActive ? .gray5 : .green1)
                .clipShape(.rect(cornerRadius: 10))
        }
        .disabled(isActive)
        .padding(.horizontal, 28)
    }
    
}

#Preview {
    VStack(spacing: 10) {
        GeneratorNavigationButton(isActive: true) {}
        GeneratorNavigationButton(isActive: false) {}
        GeneratorNavigationButton(isActive: true, title: "테스트") {}
        GeneratorNavigationButton(isActive: false, title: "테스트") {}
    }

}
