//
//  GeneratorHeaderView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI

struct GeneratorHeaderView: View {
    
    var step: Int
    
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
    }
}

#Preview {
    ZStack {
        // Background Color
        Color.backgroundWhite
            .ignoresSafeArea()
        // Content
        VStack(spacing: 20) {
            GeneratorHeaderView(step: 1)
            GeneratorHeaderView(step: 2)
            GeneratorHeaderView(step: 3)
        } //:VSTACK
    } //:ZSTACK
}
