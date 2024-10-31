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
            Image(.feedIcon)
                
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .opacity(viewModel.state.currentTab == .feed ? 0.8 : 0.4)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    EventLogManager.shared.logEvent(.clickMainTab)
                    viewModel.sendAction(.feedIconTap)
                }
            Spacer()
            
            Image(.cameraIcon)
                .frame(width: 60, height: 60)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    EventLogManager.shared.logEvent(.clickCreateTab)
                    viewModel.sendAction(.cameraIconTap)
                }


            Spacer()
            Image(.profileIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .opacity(viewModel.state.currentTab == .profile ? 0.8 : 0.4)
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
                Color.geintiBackground
                    .ignoresSafeArea()
                
            } //:ZSTACK
        )
        .shadow(type: .strong)
    }
}
