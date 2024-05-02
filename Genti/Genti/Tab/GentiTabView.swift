//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
//    @StateObject var viewModel: GeneratorViewModel = GeneratorViewModel()
    @State private var currentTab: Tab = .home
    @State private var showPhotoGenView: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                ProfileView()
                    .tag(Tab.profile)
            }
            
            CustomTabView(selectedTab: $currentTab) {
                showPhotoGenView.toggle()
            }
        } //:ZSTACK
        .fullScreenCover(isPresented: $showPhotoGenView) {
            FirstGeneratorView {
                showPhotoGenView.toggle()
            }
//            .environmentObject(viewModel)
        }
    }
}

#Preview {
    GentiTabView()
}
