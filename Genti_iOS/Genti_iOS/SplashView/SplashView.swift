//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import SDWebImageSwiftUI
import Lottie

struct SplashView: View {
    @Bindable var router: Router<MainRoute>
    var body: some View {
        
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            Text("스플래시뷰입니다")
                .foregroundStyle(.black)
                .pretendard(.headline1)
                .onAppear {
                    Task {
                        do {
                            try await Task.sleep(nanoseconds: 1000000000)
                            await MainActor.run {
                                router.routeTo(.login)
                            }
                        }

                    }
                }
        } //:ZSTACK
    }
}
