//
//  CustomTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    var onCameraPressed: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center) {
            Image(selectedTab == .home ? "Home_fill" : "Home_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedTab = .home
                }
            Spacer()
            Image("Camera")
                .frame(width: 60, height: 60)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    onCameraPressed?()
                }

            Spacer()
            Image(selectedTab == .profile ? "User_fill" : "User_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedTab = .profile
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
    }
}

fileprivate struct CustomTabViewPreView: View {
    @State private var selected: Tab = .home
    var body: some View {
        CustomTabView(selectedTab: $selected)
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
