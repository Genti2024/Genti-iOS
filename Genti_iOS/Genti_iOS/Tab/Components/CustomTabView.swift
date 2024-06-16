//
//  CustomTabView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var mainFlow: GentiMainFlow
    @Binding var currentTab: Tab
    var body: some View {
        HStack(alignment: .center) {
            Image(currentTab == .feed ? "Feed_fill" : "Feed_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    currentTab = .feed
                }
            Spacer()
            
            Image("Camera")
                .frame(width: 60, height: 60)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    mainFlow.showGeneratorView = true
                }


            Spacer()
            Image(currentTab == .profile ? "User_fill" : "User_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .padding(3)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    currentTab = .profile
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
                self.mainFlow.receiveNoti = true
            })
        .onReceive(NotificationCenter
            .default
            .publisher(for: Notification.Name("GeneratorFinished"))
            .eraseToAnyPublisher(), perform: { _ in
                self.mainFlow.showGeneratorView = false
            })
        .onReceive(NotificationCenter
            .default
            .publisher(for: Notification.Name("SelectedMyImage"))
            .eraseToAnyPublisher(), perform: { object in
                guard let post = object.object as? Post else {
                    return
                }
                self.mainFlow.selectedPost = post
            })
        .fullScreenCover(item: $mainFlow.selectedPost) { post in
            PostDetailView(imageUrl: post.imageURL)
        }
        .fullScreenCover(isPresented: $mainFlow.receiveNoti, content: {
            PhotoCompleteView()
        })
        .fullScreenCover(isPresented: $mainFlow.showGeneratorView, content: {
            FirstGeneratorView()
        })
        .fullScreenCover(isPresented: .constant(mainFlow.hasCompleted), onDismiss: { self.mainFlow.hasCompleted = false }, content: {
            PhotoCompleteView()
        })
    }
}

fileprivate struct CustomTabViewPreView: View {
    @State private var selected: Tab = .feed
    var body: some View {
        CustomTabView(currentTab: $selected)
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
