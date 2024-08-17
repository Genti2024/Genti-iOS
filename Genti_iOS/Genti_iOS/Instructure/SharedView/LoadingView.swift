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
        LottieView(type: .loading)
            .looping()
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
            }
    }
}

#Preview {
    LoadingView()
}
