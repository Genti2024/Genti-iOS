//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
    @State var currentTab: Tab = .feed
    @Bindable var router: Router<MainRoute>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                MainFeedView(viewModel: MainFeedViewModel(mainFeedUseCase: MainFeedUseCaseImpl(feedRepository: FeedRepositoryImpl(requestService: RequestServiceImpl()), userDefaultsRepository: UserDefaultsRepositoryImpl()), router: router))
                    .tag(Tab.feed)

                ProfileView(viewModel: ProfileViewModel(profileUseCase: ProfileUseCaseImpl(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())), router: router))
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
