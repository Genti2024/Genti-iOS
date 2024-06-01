//
//  ProfileView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var myImages: [Post] = []
    @Binding var settingFlow: [SettingFlow]
    @State private var isMaking: Bool = true
    
    var imageTapped: ((Post) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            
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
                        .onTapGesture {
                            self.settingFlow.append(.setting)
                        }
                }
                .padding(.horizontal, 27)
                .padding(.vertical, 46)
                
                
                if isMaking {
                    BlurView(style: .light)
                        .clipShape(.rect(cornerRadius: 18))
                        .frame(height: 75)
                        .padding(.horizontal, 16)
                        .shadow(color: .green5, radius: 13)
                        .overlay(alignment: .center) {
                            Text("세상에 없던 나만의 사진 찍는중...")
                                .pretendard(.large)
                                .foregroundStyle(.black)
                        }
                        .padding(.bottom, 20)
                }
                
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            myImages = Post.dummies
        }
    }
}

#Preview {
    ProfileView(settingFlow: .constant([]))
}
