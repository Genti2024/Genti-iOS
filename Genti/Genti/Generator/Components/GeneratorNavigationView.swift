//
//  GeneratorNavigationView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI

struct GeneratorNavigationView: View {
    
    var onBackButtonPressed: (() -> Void)? = nil
    var onXmarkPressed: (() -> Void)? = nil
    var isFirst: Bool = false
    
    var body: some View {
        HStack {
            Image("Back_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 29, height: 29)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    onBackButtonPressed?()
                }
                .opacity(isFirst ? 0 : 1)
            Spacer()
            Image("Xmark_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 29, height: 29)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    onXmarkPressed?()
                }
                
        } //:HSTACK
    }
}

#Preview {
    ZStack {
        // Background Color
        Color.black
            .ignoresSafeArea()
        // Content
        VStack(spacing: 50) {
            GeneratorNavigationView()
            GeneratorNavigationView(isFirst: true)
        }
    } //:ZSTACK

}
