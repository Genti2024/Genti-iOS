//
//  CustomTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct CustomTabView: View {
    @Bindable var router: Router<MainRoute>
    @Binding var currentTab: Tab
    var body: some View {
        HStack(alignment: .center) {
            Image(currentTab == .feed ? "Feed_fill" : "Feed_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    currentTab = .feed
                }
            Spacer()
            
            Image("Camera")
                .frame(width: 60, height: 60)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    router.routeTo(.firstGen)
                }


            Spacer()
            Image(currentTab == .profile ? "User_fill" : "User_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    currentTab = .profile
                }
        }
        .frame(height: 50)
        .padding(.horizontal, 59)
        .background(
            ZStack(alignment: .top) {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                Rectangle()
                    .fill(.gray6)
                    .frame(height: 1)
            } //:ZSTACK
        )
        .shadow(type: .strong)
    }
}

fileprivate struct CustomTabViewPreView: View {
    @State private var selected: Tab = .feed
    var body: some View {
        CustomTabView(router: .init(), currentTab: $selected)
    }
}


#Preview {
    ZStack(alignment: .bottom) {
        // Background Color
        Color.black
            .ignoresSafeArea()
        // Content
        CustomTabViewPreView()
    } //:ZSTACK
}


