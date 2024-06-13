//
//  GentiApp.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI

enum AppFlow: Hashable {
    case login
    case home
    case setting
    case notion(urlString: String)
}

final class GentiMainNavigation: ObservableObject {
    @Published var path: [AppFlow] = []
    
    func push(_ flow: AppFlow) {
        self.path.append(flow)
    }
    
    func back() {
        self.path.removeLast()
    }
    
    func popToRoot() {
        self.path.removeAll()
    }
}

@main
struct GentiApp: App {
    @StateObject var gentiNavigation = GentiMainNavigation()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var receiveNoti: Bool = false
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $gentiNavigation.path) {
                SplashView()
                    .navigationDestination(for: AppFlow.self) { path in
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

            .environmentObject(gentiNavigation)
        }
    }
}
