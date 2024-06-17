//
//  GeneratorHeaderView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI

struct GeneratorHeaderView: View {
    @Bindable var router: Router<MainRoute>
    enum HeaderType {
        case back
        case backAndDismiss
        
        var leftButtonHidden: Bool {
            switch self {
            case .back:
                true
            case .backAndDismiss:
                false
            }
        }
    }
    
    var step: Int
    var headerType: HeaderType
    
    var body: some View {
        VStack(alignment: .center, spacing: 13) {
            Image("Genti_LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 38)
            
            ProgressView(value: Float(step), total: 3)
                .frame(width: 83, height: 3)
                .background(.gray5)
                .tint(.gentiGreen)
        } //:VSTACK
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .overlay(alignment: .center) {
            HStack {
                if !headerType.leftButtonHidden {
                    Image("Back_fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 29, height: 29)
                        .padding(15)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            router.dismiss()
                        }
                }

                Spacer()
          
                Image("Xmark_fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29, height: 29)
                    .padding(15)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.dismissSheet()
                    }
            }
            .padding(.horizontal, 13)
        }
    }
}

#Preview {
    ZStack {
        // Background Color
        Color.backgroundWhite
            .ignoresSafeArea()
        // Content
        VStack(spacing: 20) {
            GeneratorHeaderView(router: .init(), step: 1, headerType: .back)
            GeneratorHeaderView(router: .init(), step: 2, headerType: .backAndDismiss)
            GeneratorHeaderView(router: .init(), step: 3, headerType: .backAndDismiss)
        } //:VSTACK
    } //:ZSTACK
}
