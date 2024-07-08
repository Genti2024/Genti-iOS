//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct PhotoCompleteView: View {

    @State var viewModel: PhotoCompleteViewViewModel
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    if viewModel.photoInfo.imageRatio == .threeSecond {
                        VerticalImageContentView(viewModel: viewModel)
                    } else {
                        HorizontalImageContentView(viewModel: viewModel)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Action
                    } label: {
                        Text("공유하기")
                            .pretendard(.headline1)
                            .foregroundStyle(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(.gentiGreen)
                            .overlay(alignment: .leading) {
                                Image("Share")
                                    .resizable()
                                    .frame(width: 29, height: 29)
                                    .padding(.leading, 20)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                        .frame(height: 18)
                    
                    Text("메인으로 이동하기")
                        .pretendard(.small)
                        .foregroundStyle(.gray3)
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            self.viewModel.sendAction(.goToMainButtonTap)
                        }
                    
                    Spacer()
                    
                    
                    Text("혹시 만들려고 했던 사진과 전혀 다른 사진이 나왔나요?")
                        .pretendard(.small)
                        .foregroundStyle(.error)
                        .underline()
                        .onTapGesture {
                            self.viewModel.sendAction(.reportButtonTap)
                        }
                    Spacer()
                }
                
                if viewModel.state.showRatingView {
                    RatingAlertView(viewModel: viewModel)
                }

                if viewModel.state.isLoading {
                    LoadingView()
                }
                
            } //:ZSTACK
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}
