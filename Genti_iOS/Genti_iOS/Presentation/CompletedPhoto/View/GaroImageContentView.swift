//
//  HorizontalImageContentView.swift
//  Genti_iOS
//
//  Created by uiskim on 6/24/24.
//

import SwiftUI

import SDWebImageSwiftUI
import Lottie

struct GaroImageContentView: View {
    
    @Bindable var viewModel: CompletedPhotoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.gentiLOGO)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.isWiderThan375pt ? 44 : 24)
                .padding(.top, UIScreen.isWiderThan375pt ? 80 : 40)
            
            Image(.charactor)
                .resizable( )
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.isWiderThan375pt ? 162 : 100)
                .padding(.top, 12)
            
            VStack {
                HStack(spacing: 0) {
                    Text("하나뿐인 나만의 사진")
                        .pretendard(.headline1)
                        .foregroundStyle(.green1)
                    
                    Text("이")
                        .pretendard(.headline3)
                }
                Text("완성되었어요!")
                    .pretendard(.headline3)
            }
            .frame(height: 57)
            .foregroundStyle(.black)
            
            Spacer()
                .frame(height: 16)
            
            WebImage(url: URL(string: viewModel.state.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.isWiderThan375pt ? 212 : 180)
                    .addDownloadButton { self.viewModel.sendAction(.downloadButtonTap) }
                    .cornerRadiusWithBorder(style: LinearGradient.borderGreen, radius: 15, lineWidth: 2)
                    .onTapGesture {
                        self.viewModel.sendAction(.imageTap)
                    }
            } placeholder: {
                LottieView(type: .imageLoading)
                    .looping()
                    .frame(width: 80, height: 80)
            }
            .onSuccess { image, _, _ in
                self.viewModel.sendAction(.imageLoad(image))
            }
            
            Spacer().frame(height: 18)
            
            Text("사진이 마이페이지에 저장되었어요!")
                .pretendard(.small)
                .foregroundStyle(.gray3)
        }
        .frame(height: UIScreen.isWiderThan375pt ? 640 : 520)
        .frame(maxWidth: .infinity)
        .background(alignment: .top) {
            Rectangle()
                .fill(.backgroundWhite)
                .clipShape(.rect(cornerRadius: 30))
                .shadow(type: .strong)
                .overlay(alignment: .top) {
                    LinearGradient.backgroundPurple1
                        .frame(height: 316)
                }
        }
    }
}

//#Preview {
//    HorizontalImageContentView(viewModel: PhotoCompleteViewViewModel(router: .init()))
//}






