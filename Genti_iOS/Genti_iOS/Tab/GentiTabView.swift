//
//  GentiTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct GentiTabView: View {
    @State var viewModel: TabViewModel
    
    init(viewModel: TabViewModel) {
        self.viewModel = viewModel
    }
    
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
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
    }
}

//#Preview {
//    GentiTabView(router: .init())
//}
