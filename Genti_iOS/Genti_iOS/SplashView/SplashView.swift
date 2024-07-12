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
        LottieView(type: .splash)
            .playing(loopMode: .playOnce)
            .animationDidFinish { _ in
                router.routeTo(.login)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}




