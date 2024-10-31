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
    let subtitle: String?
    let imageAssetName: String
    
    init(title: String, isActive: Bool, imageAssetName: String, subtitle: String?, _ action: @escaping () -> Void) {
        self.action = action
        self.isActive = isActive
        self.title = title
        self.subtitle = subtitle
        self.imageAssetName = imageAssetName
    }
    
    var body: some View {
        Rectangle()
            .fill(.buttonBackground)
            .frame(width: 150, height: 150)
            .overlay {
                if isActive {
                    LinearGradient.gentiGradation
                        .opacity(0.1)
                }
            }
            .cornerRadius(6, corners: .allCorners)
            .overlay {
                VStack(spacing: 14) {
                    Image(imageAssetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 4) {
                        Text(title)
                            .pretendard(.body_14_bold)
                            .foregroundStyle(.white)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .pretendard(.body_14_medium)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }
            .if(isActive, content: { view in
                view.cornerRadiusWithBorder(style: LinearGradient.gentiGradationOpacity, radius: 6, lineWidth: 1)
            })
            
            .background(.black.opacity(0.001))
            .onTapGesture {
                action()
            }
    }
}

//#Preview {
//    VStack {
//        GentiBorderButton(title: "테스트", isActive: true) {}
//        GentiBorderButton(title: "테스트", isActive: false) {}
//    }
//}
