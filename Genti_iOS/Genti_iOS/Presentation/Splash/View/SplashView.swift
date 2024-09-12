//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import Lottie

struct SplashView: View {
    @State var viewModel: SplashViewModel
    
    var body: some View {
        LottieView(type: .splash)
            .playing()
            .animationDidFinish { _ in
                self.viewModel.sendAction(.splashAnimationFinished)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea()
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            .customAlert(alertType: $viewModel.state.showAlert)
    }
}

#Preview {
    SplashView(viewModel: .init(router: .init(), splashUseCase: SplashUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl())))
}
