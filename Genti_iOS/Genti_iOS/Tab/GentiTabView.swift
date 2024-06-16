//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
    @State var currentTab: Tab = .feed
    @EnvironmentObject var mainFlow: GentiMainFlow
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                MainFeedView()
                    .tag(Tab.feed)

                ProfileView()
                .tag(Tab.profile)
            }
            
            CustomTabView(currentTab: $currentTab)
        } //: ZSTACK
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
    }
}


#Preview {
    GentiTabView()
}
