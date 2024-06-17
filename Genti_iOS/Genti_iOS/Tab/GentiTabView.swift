//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
    @State var currentTab: Tab = .feed
    @State var router: Router<MainRoute>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                MainFeedView()
                    .tag(Tab.feed)

                ProfileView(router: router)
                .tag(Tab.profile)
            }
            
            CustomTabView(router: router, currentTab: $currentTab)
        } //: ZSTACK
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    GentiTabView(router: .init())
}