//
//  GentiApp.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

struct GentiApp: View {
    @EnvironmentObject var gentiNavigation: GentiMainFlow
    var body: some View {
        NavigationStack(path: $gentiNavigation.mainPath) {
            SplashView()
                .navigationDestination(for: MainFlow.self) { path in
                    switch path {
                    case .home:
                        GentiTabView()
                    case .login:
                        LoginView()
                    case .setting:
                        SettingView()
                    case .notion(urlString: let urlString):
                        GentiWebView(urlString: urlString)
                    }
                }
        }
    }
}

#Preview {
    GentiApp()
}
