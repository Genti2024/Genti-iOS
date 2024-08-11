//
//  GentiBorderButton.swift
//  Genti_iOS
//
//  Created by uiskim on 8/11/24.
//

import SwiftUI

struct GentiBorderButton: View {
    
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
            .pretendard(isActive ? .headline1 : .headline2)
            .frame(width: 137, height: 39)
            .foregroundStyle(isActive ? .green1 : .gray3)
            .cornerRadiusWithBorder(style: isActive ? .green1 : .gray3, radius: 8, lineWidth: 1)
            .background(.black.opacity(0.001))
            .onTapGesture {
                action()
            }
        
    }
}

#Preview {
    VStack {
        GentiBorderButton(title: "테스트", isActive: true) {}
        GentiBorderButton(title: "테스트", isActive: false) {}
    }
}
