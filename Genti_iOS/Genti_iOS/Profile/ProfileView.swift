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
        GeometryReader { geometry in
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
                        
                        StraggeredGrid(list: viewModel.state.myImages, spacing: 1) { object in
                            ImageLoaderView(urlString: object.imageURL, ratio: object.ratio, width: (geometry.size.width-1)/2)
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

                    }
                    .shadow(type: .soft)
                }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
        .refreshable {
            print(#fileID, #function, #line, "- refresh profile")
        }
    }
}

//#Preview {
//    ProfileView(router: .init())
//}



