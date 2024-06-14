//
//  CustomTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    
    @State private var selectedPost: Post? = nil
    @State private var receiveNoti: Bool = false
    @State private var showGeneratorView: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            Image(selectedTab == .feed ? "Feed_fill" : "Feed_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedTab = .feed
                }
            Spacer()
            
            Image("Camera")
                .frame(width: 60, height: 60)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    showGeneratorView = true
                }


            Spacer()
            Image(selectedTab == .profile ? "User_fill" : "User_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    selectedTab = .profile
                }
        }
        .frame(height: 50)
        .padding(.horizontal, 59)
        .background(
            ZStack(alignment: .top) {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                Rectangle()
                    .fill(.gray6)
                    .frame(height: 1)
            } //:ZSTACK
        )
        .onReceive(NotificationCenter
            .default
            .publisher(for: Notification.Name("PushNotificationReceived"))
            .eraseToAnyPublisher(), perform: { _ in
                self.showGeneratorView = false
                self.selectedPost = nil
                receiveNoti = true
            })
        .onReceive(NotificationCenter
            .default
            .publisher(for: Notification.Name("GeneratorFinished"))
            .eraseToAnyPublisher(), perform: { _ in
                self.showGeneratorView = false
            })
        .onReceive(NotificationCenter
            .default
            .publisher(for: Notification.Name("SelectedMyImage"))
            .eraseToAnyPublisher(), perform: { object in
                guard let post = object.object as? Post else {
                    return
                }
                self.selectedPost = post
            })
        .fullScreenCover(item: $selectedPost) { post in
            PostDetailView(imageUrl: post.imageURL)
        }
        .fullScreenCover(isPresented: $receiveNoti, content: {
            PhotoCompleteView()
        })
        .fullScreenCover(isPresented: $showGeneratorView, content: {
            FirstGeneratorView()
        })
    }
}

fileprivate struct CustomTabViewPreView: View {
    @State private var selected: Tab = .feed
    var body: some View {
        CustomTabView(selectedTab: $selected)
    }
}


#Preview {
    ZStack(alignment: .bottom) {
        // Background Color
        Color.black
            .ignoresSafeArea()
        // Content
        CustomTabViewPreView()
    } //:ZSTACK
}
