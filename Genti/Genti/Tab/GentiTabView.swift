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
                
                // MARK: - 4. 가운데 아래 카메라 버튼을 누르면 FirstGeneratorView가 나타남
                // firstGeneratorView는 들어가보시면 navigationstack으로 감쌌습니다
                FirstGeneratorView()
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
        .fullScreenCover(isPresented: $showCompleteView, onDismiss: {
//            self.currentTab = .home
        }, content: {
            GenerateCompleteView()
        })
    }
}

#Preview {
    GentiTabView()
}
