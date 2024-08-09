//
//  LoadingView.swift
//  Genti
//
//  Created by uiskim on 6/5/24.
//

import SwiftUI

import Lottie

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Background Color
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            // Content
            LottieView(type: .loading)
                .looping()
                .frame(width: 100, height: 100)
        } //:ZSTACK
    }
}

#Preview {
    LoadingView()
}
