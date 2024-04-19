//
//  HomeView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    @State private var scrollViewOffset: CGFloat  = 0
    var body: some View {
        ZStack {
            VStack {
                Color.green3
                Color.backgroundWhite
            }
            ScrollView {
                VStack(spacing: 18) {
                    header
                    feed
                } //:VSTACK
                .padding(.bottom, 120)
                .background(.backgroundWhite)
            } //: SCROLLVIEW
            .scrollIndicators(.hidden)
            
            if scrollViewOffset < 20 {
                uploadButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 80)
                    .padding(.trailing, 20)
                    .transition(AnyTransition(.move(edge: .top).combined(with: .opacity)))
            }
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            if scrollViewOffset < 20 {
                Rectangle()
                    .frame(height: 0)
                    .background(.backgroundWhite)
            }
        }
        .animation(.snappy, value: scrollViewOffset)

    }
    
    private var header: some View {
        ZStack(alignment: .bottom) {
            Image("Home_navigationBG")
            HStack {
                Image("Genti_logo_black")
                Spacer()
                Image("Upload")
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        print("업로드버튼이 눌림")
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
    
    private var feed: some View {
        LazyVStack(spacing: 18) {
            ForEach(0..<10) { _ in
                FeedView()
                    .padding(.horizontal, 16)
            }
        }
    }
    
    private var uploadButton: some View {
        Image("Upload_Stroke")
            .frame(width: 60, height: 60)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .onTapGesture {
                print("업로드버튼 눌림")
            }
    }
}

#Preview {
    HomeView()
}
