//
//  HomeView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    var feeds: [Feed] = Feed.mocks
    @State private var scrollViewOffset: CGFloat  = 0
    var body: some View {
        ZStack {
            VStack {
                Color.green3
                Color.backgroundWhite
            }
            ScrollView {
                VStack(spacing: 18) {
                    headerView()
                    feedView()
                } //:VSTACK
                .padding(.bottom, 120)
                .background(.backgroundWhite)
            } //: SCROLLVIEW
            .scrollIndicators(.hidden)
            
            if scrollViewOffset < 20 {
                uploadButton()
                    .transition(AnyTransition(.move(edge: .top).combined(with: .opacity)))
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            if scrollViewOffset < 20 {
                Rectangle()
                    .frame(height: 0)
                    .background(.backgroundWhite)
                    .transition(.fade)
            }
        }
        .animation(.snappy, value: scrollViewOffset)
    }
    
    private func headerView() -> some View {
        ZStack(alignment: .bottom) {
            Image("Home_navigationBG")
            HStack {
                Image("Genti_logo_black")
                Spacer()
                Image("Upload")
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        print("업로드버튼 눌림")
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.bottom, 10)
            .readingFrame { frame in
                scrollViewOffset = frame.minY
            }
        }
    }
    
    private func feedView() -> some View {
        LazyVStack(spacing: 18) {
            ForEach(feeds) {
                FeedView(
                    profileImage: $0.profileImage,
                    userName: $0.userName,
                    mainImage: $0.mainImage,
                    description: $0.description,
                    likeCount: Int.random(in: 1...100)) {
                        
                    }
                    .padding(.horizontal, 16)
            }
        }
    }
    
    private func uploadButton() -> some View {
        Image("Upload_Stroke")
            .frame(width: 60, height: 60)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .onTapGesture {
                print("업로드버튼 눌림")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, 80)
            .padding(.trailing, 20)
    }
}

#Preview {
    HomeView()
}
