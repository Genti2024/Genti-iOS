//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

import PopupView

struct PhotoCompleteView: View {

    @State var viewModel: PhotoCompleteViewViewModel

    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                if viewModel.photoInfo.imageRatio == .threeSecond {
                    VerticalImageContentView(viewModel: viewModel)
                } else {
                    HorizontalImageContentView(viewModel: viewModel)
                }
                
                Spacer()
                
                ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                    Text("공유하기")
                        .shareStyle()
                }
                .disabled(viewModel.disabled)
                
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
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background {
                Color.backgroundWhite
                    .ignoresSafeArea()
            }
            .overlay(alignment: .center) {
                if viewModel.state.isLoading {
                    LoadingView()
                }
            }
        }
        .addCustomPopup(isPresented: $viewModel.state.showRatingView, popupType: .rating)
        .onReceive(NotificationCenter.default.publisher(for: .init("ratingCompleted"))) { _ in
            self.viewModel.sendAction(.ratingActionIsDone)
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}
