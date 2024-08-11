//
//  ProfileView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct ProfileView: View {
 
    @State var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("마이페이지")
                    .pretendard(.headline1)
                    .foregroundStyle(.black)
                Spacer()
                Image("Setting")
                    .onTapGesture {
                        viewModel.sendAction(.gearButtonTap)
                    }
            }
            .padding(.horizontal, 27)
            .padding(.vertical, 46)
            
            
            if viewModel.state.hasInProgressImage {
                BlurView(style: .light)
                    .clipShape(.rect(cornerRadius: 18))
                    .frame(height: 75)
                    .padding(.horizontal, 16)
                    .shadow(type: .soft)
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
                    .overlay(alignment: .center) {
                        Text("내가 만든 사진")
                            .pretendard(.normal)
                            .foregroundStyle(.black)
                    }
                
                Rectangle()
                    .fill(.gray6)
                    .frame(height: 2)
                
                if viewModel.state.myImages.isEmpty {
                    BlurView(style: .systemUltraThinMaterialLight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .center) {
                            VStack(spacing: 37) {
                                Image(.exclamation)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 42, height: 86)
                                
                                Text("아직 내가 만든 사진이 없어요")
                                    .pretendard(.headline1)
                                    .foregroundStyle(.gray3)
                            }
                        }

                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 1),GridItem(.flexible(), spacing: 1),GridItem(.flexible(), spacing: 1)], spacing: 1) {
                                ForEach(viewModel.state.myImages) { image in
                                    ImageLoaderView(urlString: image.imageURL, resizingMode: .fill, ratio: .square)
                                        .onTapGesture {
                                            viewModel.sendAction(.imageTap(image.imageURL))
                                        }
                                        .id(image.id)
                                }
                            }
                        }
                        .onAppear {
                            guard let firstId = viewModel.state.myImages.first?.id else { return }
                            proxy.scrollTo(firstId, anchor: .top)
                        }
                    }
                }
            }
            .shadow(type: .soft)
        }
        .background {
            ZStack {
                Color.backgroundWhite
                    .ignoresSafeArea()
                
                Image("Mypage_Background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea()
            }

        }
        .toolbar(.hidden, for: .navigationBar)
        .onFirstAppear {
            viewModel.sendAction(.viewWillAppear)
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("profileReload"))) { _ in
            self.viewModel.sendAction(.reload)
        }
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}

//#Preview {
//    ProfileView(router: .init())
//}



