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
        VStack {
            ScrollView {
                scrollHederView()
                feedsView()
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.sendAction(.refresh)
            }
        }
        .background {
            Color.geintiBackground
                .ignoresSafeArea()
        }
        .onFirstAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    private func feedsView() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.state.feeds, id: \.id) { feed in
                FeedComponent(imageUrl: feed.imageUrl, description: feed.description, ratio: feed.ratio)
            }
        }
        .readingFrame { frame in
            withAnimation {
                viewModel.sendAction(.scroll(offset: frame.origin.y))
            }
        }
    }
    private func scrollHederView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(.gentiLogoGreen)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 77, height: 23)
                
                Spacer()
                
                Image(.infoIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        self.viewModel.sendAction(.genfluencerExplainTap)
                    }
            }
            .frame(height: 44)
            
            Spacer()
                .frame(height: 6)
            
            Text("젠플루언서들이 만든 사진을 둘러보세요.")
                .pretendard(.subtitle1_18_bold)
                .foregroundStyle(.white)
                .frame(height: 26)
            
            Spacer()
                .frame(height: 2)
            
            Text("여러분들이 만든 사진은 자동으로 업로드되지 않습니다.")
                .pretendard(.body_14_medium)
                .foregroundStyle(.white.opacity(0.4))
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
//
//#Preview {
//    MainFeedView()
//}
