//
//  GentiApp.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

struct GentiApp: View {

    var body: some View {
        RoutingView(Router<MainRoute>()) { router in
            SignInView(viewModel: SignInViewModel(signInUseCase: SignInUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: .init()))
//            SplashView(splashViewModel: SplashViewModel(router: router, splashUseCase: SplashUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl())))
        }
    }
}

#Preview {
    GentiApp()
}
