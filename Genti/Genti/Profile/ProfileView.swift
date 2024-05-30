//
//  ProfileView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var myImages: [Post] = []
    
    var imageTapped: ((Post) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Color
            Image("Mypage_Background")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            // Content
            VStack {
                HStack {
                    Text("마이페이지")
                        .pretendard(.headline1)
                        .foregroundStyle(.black)
                    Spacer()
                    Image("Setting")
                }
                .padding(.horizontal, 27)
                .padding(.vertical, 46)
                
                VStack(spacing: 0) {
                    BlurView(style: .light)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                        .frame(height: 50)
                        .shadow(color: .green5, radius: 13)
                        .overlay(alignment: .center) {
                            Text("내가 만든 사진")
                                .pretendard(.normal)
                                .foregroundStyle(.black)
                        }
                    
                    StraggeredGrid(list: myImages, spacing: 1) { object in
                        PostCardView(post: object)
                            .onTapGesture {
                                imageTapped?(object)
                            }
                    }

                }

            }
        } //:ZSTACK
        .onAppear {
            myImages = Post.dummies
        }
    }
}

#Preview {
    ProfileView()
}
