//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

enum GeneratorFlow: Hashable {
    case second, thrid
}

struct GentiTabView: View {

    @State private var currentTab: Tab = .home
    @State private var showCompleteView: Bool = false
    @State var generateFlow: [GeneratorFlow] = []
    @StateObject var genteratorViewModel = GeneratorViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                NavigationStack(path: $generateFlow) {
                    FirstGeneratorView(generateFlow: $generateFlow)
                        .navigationDestination(for: GeneratorFlow.self) { genType in
                            switch genType {
                            case .second:
                                SecondGeneratorView(generateFlow: $generateFlow)
                            case .thrid:
                                ThirdGeneratorView(generateFlow: $generateFlow)
                            }
                        }

                }
                .environmentObject(genteratorViewModel)
                .tag(Tab.generator)

                
                ProfileView()
                    .tag(Tab.profile)
            }
            
            CustomTabView(selectedTab: $currentTab)
        } //:ZSTACK
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GeneratorCompleted"))) { _ in
            self.currentTab = .home
            self.showCompleteView.toggle()
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showCompleteView, onDismiss: {
            self.genteratorViewModel.reset()
            self.generateFlow.removeAll()
            self.currentTab = .home
        }, content: {
            GenerateCompleteView()
        })
    }
}

#Preview {
    GentiTabView()
}
