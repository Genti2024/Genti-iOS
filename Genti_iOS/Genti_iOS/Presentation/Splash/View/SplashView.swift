//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import Lottie

struct SplashView: View {
    @State var splashViewModel: SplashViewModel
    
    var body: some View {
        LottieView(type: .splash)
            .playing()
            .animationDidFinish { _ in
                self.splashViewModel.execute(.splashAnimationFinished)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea()
            .background {
                Color.backgroundWhite
            }
    }
}

#Preview {
    SplashView(splashViewModel: .init(router: .init(), splashUseCase: SplashUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl())))
}
