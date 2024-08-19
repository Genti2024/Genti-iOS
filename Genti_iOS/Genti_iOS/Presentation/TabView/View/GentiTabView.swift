//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
    @State var viewModel: TabViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.state.currentTab) {
                MainFeedView(viewModel: MainFeedViewModel(feedRepository: FeedRepositoryImpl(requestService: RequestServiceImpl()), userDefaultsRepository: UserDefaultsRepositoryImpl(), router: viewModel.router))
                    .tag(Tab.feed)

                ProfileView(viewModel: ProfileViewModel(profileUseCase: ProfileUseCaseImpl(imageRepository: ImageRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())), router: viewModel.router))
                .tag(Tab.profile)
            }
            
            CustomTabView(viewModel: $viewModel)
        } //: ZSTACK
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .overlay(alignment: .center) {
            if viewModel.state.isLoading {
                LoadingView()
            }
        }
        .customAlert(alertType: $viewModel.state.showAlert)
        .onNotificationRecieved(name: Notification.Name(rawValue: "PushNotificationReceived")) { _ in
            self.viewModel.sendAction(.pushReceived)
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
    }
}

//#Preview {
//    GentiTabView(router: .init())
//}
