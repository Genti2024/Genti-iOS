//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

struct SplashView: View {
    @State var splashViewModel: SplashViewModel
    
    var body: some View {
        Text("스플래시뷰입니다")
            .foregroundStyle(.black)
            .pretendard(.headline1)
            .onAppear {
                Task {
                    do {
                        try await Task.sleep(nanoseconds: 1000000000)
                        await MainActor.run {
                            self.splashViewModel.sendAction(.splashAnimationFinished)
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background {
                Color.backgroundWhite
                    .ignoresSafeArea()
            }
    }
}
