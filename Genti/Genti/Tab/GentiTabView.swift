//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {

    @State private var currentTab: Tab = .home
    @State private var showCompleteView: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                FirstGeneratorView()
                    .tag(Tab.generator)
                
                ProfileView()
                    .tag(Tab.profile)
            }
            
            CustomTabView(selectedTab: $currentTab)
        } //:ZSTACK
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GeneratorCompleted"))) { _ in
            self.showCompleteView.toggle()
        }
        .fullScreenCover(isPresented: $showCompleteView, onDismiss: {
            self.currentTab = .home
        }, content: {
            GenerateCompleteView()
        })
    }
}

#Preview {
    GentiTabView()
}
