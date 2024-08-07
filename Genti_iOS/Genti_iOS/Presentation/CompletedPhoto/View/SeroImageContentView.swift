//
//  VerticalImageContentView.swift
//  Genti_iOS
//
//  Created by uiskim on 6/24/24.
//

import SwiftUI

struct SeroImageContentView: View {
    @Bindable var viewModel: CompletedPhotoViewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Genti_LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 44)
                .padding(.top, 80)
            
            
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
            .padding(.top, 29)
            
            Spacer()
                .frame(height: 16)
            
            viewModel.getImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 360)
                .addDownloadButton { self.viewModel.sendAction(.downloadButtonTap) }
                .cornerRadiusWithBorder(style: LinearGradient.borderGreen, radius: 15, lineWidth: 2)
                .onTapGesture {
                    print(#fileID, #function, #line, "- imagetap")
                    self.viewModel.sendAction(.imageTap)
                }
                .onAppear {
                    self.viewModel.sendAction(.viewWillAppear)
                }
            
            
            Spacer()
                .frame(height: 18)
            Text("사진이 마이페이지에 저장되었어요!")
                .pretendard(.small)
                .foregroundStyle(.gray3)
        }
        .frame(height: 640)
        .frame(maxWidth: .infinity)
        
        .background(alignment: .top) {
            Rectangle()
                .fill(.backgroundWhite)
                .clipShape(.rect(cornerRadius: 30))
                .shadow(type: .strong)
                .overlay(alignment: .top) {
                    LinearGradient.backgroundPurple1
                        .frame(height: 171)
                }
        }
    }
}

//#Preview {
//    VerticalImageContentView(viewModel: PhotoCompleteViewViewModel(router: .init()))
//}


