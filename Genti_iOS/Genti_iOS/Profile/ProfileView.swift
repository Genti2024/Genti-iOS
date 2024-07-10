//
//  ProfileView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct ProfileView: View {
 
    @State var viewModel: ProfileViewModel
    
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
                        .shadow(type: .soft)
                        .overlay(alignment: .center) {
                            Text("내가 만든 사진")
                                .pretendard(.normal)
                                .foregroundStyle(.black)
                        }
                    
                    
                    StraggeredGrid(list: viewModel.state.myImages, spacing: 1) { object in
                        ImageLoaderView(urlString: object.imageURL, ratio: object.ratio, width: (Constants.screenWidth-1)/2)
                            .onTapGesture {
                                viewModel.sendAction(.imageTap(object.imageURL))
                            }
                            .onAppear {
                                guard let index = viewModel.state.myImages.firstIndex(where: { $0.id == object.id }) else { return }
                                
                                if index == viewModel.state.myImages.count - 1 {
                                    viewModel.sendAction(.reachBottom)
                                }
                            }
                    }
                    .background {
                        BlurView(style: .light)
                            .overlay(alignment: .center) {
                                if viewModel.state.myImages.isEmpty {
                                    VStack(spacing: 37) {
                                        Image("ExclamationImage")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 43)
                                        
                                        Text("아직 내가 만든 사진이 없어요")
                                            .pretendard(.headline1)
                                            .foregroundStyle(.gray3)
                                    }
                                }
                            }
                    }
                }
            }
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
        .onFirstAppear {
            viewModel.sendAction(.viewWillAppear)
        }
        .refreshable {
            print(#fileID, #function, #line, "- refresh profile")
        }
    }
}

//#Preview {
//    ProfileView(router: .init())
//}



