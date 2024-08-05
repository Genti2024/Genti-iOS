//
//  MainFeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct MainFeedView: View {
    
    @State var viewModel: MainFeedViewModel
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                ScrollView {
                    scrollHederView()
                    feedsView()
                }
                .refreshable {
                    print(#fileID, #function, #line, "- refresh main feed")
                }
            }.zIndex(0)
            
            if !viewModel.state.isLogoHidden {
                logoView().zIndex(1)
            }
        } //:ZSTACK
        .background {
            Color.backgroundWhite
                .ignoresSafeArea()
        }
        .overlay {
            if viewModel.state.isLoading {
                LoadingView()
            }
        }
        .onFirstAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    private func feedsView() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.state.feeds, id: \.id) { feed in
                FeedComponent(mainImage: feed.mainImage, description: feed.description, ratio: feed.ratio)
            }
        }
        .readingFrame { frame in
            withAnimation {
                viewModel.sendAction(.scroll(offset: frame.origin.y))
            }
        }
    }
    private func scrollHederView() -> some View {
        VStack {
            Spacer()
                .frame(height: 12)
            Text("젠플루엔서들이 만든 사진이에요")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 22)
            Text("젠플루언서란?")
                .pretendard(.number)
                .foregroundStyle(.gentiGreen)
                .underline()
                .frame(height: 25)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    viewModel.sendAction(.genfluencerExplainTap)
                }
            Spacer()
                .frame(height: 11)
            Text("*여러분이 만든 사진은 자동으로 업로드 되지 않아요")
                .foregroundStyle(.gray2)
                .pretendard(.description)
                .frame(maxWidth: .infinity)
                .frame(height: 16)
                .padding(.bottom, 13)
                .background {
                    LinearGradient.backgroundGreen1
                }
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        }
    }
    private func headerView() -> some View {
        VStack {
            Spacer()
            Image("Genti_logo_green")
                .frame(height: 23)
                .aspectRatio(contentMode: .fill)
        }
        .frame(height: 37)
    }
    private func logoView() -> some View {
        Image("Sparks")
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
//
//#Preview {
//    MainFeedView()
//}
