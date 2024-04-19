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
            ScrollView {
                ZStack {
                    Color.backgroundWhite
                    VStack {
                        header
                        feed
                    } //:VSTACK
                    .padding(.bottom, 120)
                }
            } //: SCROLLVIEW
            .background(
                VStack {
                    Color.green3
                    Color.backgroundWhite
                }
            )
            .scrollIndicators(.hidden)
            
            if scrollViewOffset < 20 {
                uploadButton
                    .transition(AnyTransition(.move(edge: .top).combined(with: .opacity)))
            }
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            if scrollViewOffset < 20 {
                Rectangle()
                    .frame(height: 0)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.backgroundWhite)
            }
        }
        .animation(.snappy, value: scrollViewOffset)

    }
    
    private var header: some View {
        ZStack(alignment: .bottom) {
            // Background Color
            Image("Home_navigationBG")
            // Content
            HStack {
                Image("Genti_logo_black")
                Spacer()
                Image("Upload")
            } //:HSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.bottom, 10)
            .readingFrame { frame in
                scrollViewOffset = frame.minY
            }
        } //:ZSTACK
    }
    
    private var feed: some View {
        LazyVStack(spacing: 18) {
            ForEach(0..<10) { _ in
                FeedView()
                    .padding(.top, 18)
                    .padding(.horizontal, 16)
            }
        }
    }
    
    private var uploadButton: some View {
        Image("Upload_Stroke")
            .frame(width: 60, height: 60)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, 80)
            .padding(.trailing, 20)
    }
}

#Preview {
    HomeView()
}
