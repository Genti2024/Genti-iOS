//
//  HomeView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct HomeView: View {
    @State private var logoHidden: Bool = false
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            ZStack {
                VStack {
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
                    ScrollView {
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
                        VStack(spacing: 0) {
                            HomeFeedView()
                            HomeFeedView(description: Constants.text(length: 100))
                            HomeFeedView(description: Constants.text(length: 50))
                            HomeFeedView(description: Constants.text(length: 100))
                            HomeFeedView(mainImage: "SampleImage23", description: Constants.text(length: 50))
                            HomeFeedView()
                            HomeFeedView(description: Constants.text(length: 100))
                            HomeFeedView(description: Constants.text(length: 50))
                            HomeFeedView(description: Constants.text(length: 100))
                            HomeFeedView(mainImage: "SampleImage23", description: Constants.text(length: 50))
                            
                        } //:VSTACK
                        .readingFrame { frame in
                            withAnimation {
                                self.logoHidden = frame.origin.y < 165 ? true : false
                            }

                        }
                    }
                }
                
                if !self.logoHidden {
                    Image("Sparks")
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }

            } //:ZSTACK

        } //:ZSTACK
    }
}

#Preview {
    HomeView()
}
