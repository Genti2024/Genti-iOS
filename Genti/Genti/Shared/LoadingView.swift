//
//  LoadingView.swift
//  Genti
//
//  Created by uiskim on 6/5/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Background Color
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            // Content
            LottieView(lottieFile: "ProgressLottie")
                .frame(width: 100, height: 100)
        } //:ZSTACK
    }
}

#Preview {
    LoadingView()
}
