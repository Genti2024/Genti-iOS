//
//  RequestWaitingView.swift
//  Genti_iOS
//
//  Created by uiskim on 8/11/24.
//

import SwiftUI

import Lottie

struct RequestWaitingView: View {
    var body: some View {
        LottieView(type: .waiting)
            .playing(loopMode: .loop)
            .frame(width: 250, height: 250)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
            }
    }
}

#Preview {
    RequestWaitingView()
}
