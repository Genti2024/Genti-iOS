//
//  CustomTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct CustomTabView: View {

    @Binding var viewModel: TabViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Image(viewModel.state.currentTab == .feed ? "Feed_fill" : "Feed_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    EventLogManager.shared.logEvent(.clickMainTab)
                    viewModel.sendAction(.feedIconTap)
                }
            Spacer()
            
            Image("Camera")
                .frame(width: 60, height: 60)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    EventLogManager.shared.logEvent(.clickCreateTab)
                    viewModel.sendAction(.cameraIconTap)
                }


            Spacer()
            Image(viewModel.state.currentTab == .profile ? "User_fill" : "User_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    EventLogManager.shared.logEvent(.clickMyPageTab)
                    viewModel.sendAction(.profileIconTap)
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
