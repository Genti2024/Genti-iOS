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
                    .foregroundStyle(.white)
                Spacer()
                Image("Setting")
                    .onTapGesture {
                        viewModel.sendAction(.gearButtonTap)
                    }
            }
            .frame(height: 44)
            .padding(.horizontal, 16)
            .padding(.top, 16)

            
            if viewModel.state.hasInProgressImage {
                Image(.progressIcon)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack(spacing: 0) {
                
                if viewModel.state.myImages.isEmpty {
                    
                    VStack(spacing: 0) {
                        Image(.infoIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        
                        Spacer()
                            .frame(height: 24)
                        
                        Text("아직 내가 만든 사진이 없어요.")
                            .pretendard(.title1_24_bold)
                            .foregroundStyle(.white)
                            .frame(height: 30)
                        Text("세상에 하나뿐인 나만의 사진을 만들어보세요!")
                            .pretendard(.body_14_medium)
                            .foregroundStyle(.white.opacity(0.6))
                            .frame(height: 20)
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
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 16)
        }
        .background {
            Color.geintiBackground
                .ignoresSafeArea()

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



