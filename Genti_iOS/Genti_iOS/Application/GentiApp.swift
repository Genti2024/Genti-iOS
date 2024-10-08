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
            SplashView(viewModel: SplashViewModel(router: router, splashUseCase: SplashUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl())))
        }
    }
}

#Preview {
    GentiApp()
}
