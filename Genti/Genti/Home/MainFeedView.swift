//
//  MainFeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct MainFeedView: View {
    @State private var logoHidden: Bool = false
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            ZStack {
                VStack {
                    headerView()
                    ScrollView {
                        scrollHederView()
                        feedsView()
                    }
                }
                
                if !self.logoHidden {
                    logoView()
                }
            } //:ZSTACK
        } //:ZSTACK
    }
    
    private func feedsView() -> some View {
        VStack(spacing: 0) {
            FeedComponent()
            FeedComponent(description: Constants.text(length: 100))
            FeedComponent(description: Constants.text(length: 50))
            FeedComponent(description: Constants.text(length: 100))
            FeedComponent(mainImage: "SampleImage23", description: Constants.text(length: 50))
            FeedComponent()
            FeedComponent(description: Constants.text(length: 100))
            FeedComponent(description: Constants.text(length: 50))
            FeedComponent(description: Constants.text(length: 100))
            FeedComponent(mainImage: "SampleImage23", description: Constants.text(length: 50))
            
        } //:VSTACK
        .readingFrame { frame in
            withAnimation {
                self.logoHidden = frame.origin.y < 165 ? true : false
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
                .frame(height: 16)
            Spacer()
                .frame(height: 20)
            Text("*여러분이 만든 사진은 자동으로 업로드 되지 않아요")
                .foregroundStyle(.gray2)
                .pretendard(.description)
                .frame(maxWidth: .infinity)
                .frame(height: 16)
                .padding(.bottom, 13)
                .background {
                    LinearGradient(colors: [.gentiGreen.opacity(0), .gentiGreen.opacity(1)], startPoint: .top, endPoint: .bottom)
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
                .onTapGesture {
                    let images = ["SampleImage23", "SampleImage32"]
                    NotificationCenter.default.post(name: Notification.Name("PhotoMakeCompleted"), object: nil, userInfo: ["ImageName": images.randomElement()!])
                }
        }
        .frame(height: 37)
    }
    private func logoView() -> some View {
        Image("Sparks")
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    MainFeedView()
}
