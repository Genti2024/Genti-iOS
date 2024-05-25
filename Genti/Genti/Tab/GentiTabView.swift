//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {

    @State private var currentTab: Tab = .home
    
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
    }
}

#Preview {
    GentiTabView()
}
