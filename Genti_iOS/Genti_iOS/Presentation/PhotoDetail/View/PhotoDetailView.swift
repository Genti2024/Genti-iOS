//
//  PhotoDetailView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct PhotoDetailView: View {

    @State var viewModel: PhotoDetailViewModel
    
    var body: some View {
        
        WebImage(url: URL(string: viewModel.state.imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .addDownloadButton { self.viewModel.sendAction(.downloadButtonTap(from: .detail)) }
        } placeholder: {
            Image(uiImage: UIImage(resource: .camera))
        }
        .onSuccess { image, _, _ in
            self.viewModel.sendAction(.imageLoad(image))
        }
        .addXmark(top: 3, trailing: 20) { viewModel.sendAction(.xmarkTap) }
        
        .presentationBackground {
            BlurView(style: .systemUltraThinMaterialDark)
                .onTapGesture {
                    viewModel.sendAction(.backgroundTap)
                }
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 10) {
                Image(.downloadButtonNew)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Text("저장하기")
                    .pretendard(.subtitle2_16_bold)
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.geintiBackground)
            .background(.gentiGreenNew)
            .cornerRadius(10, corners: .allCorners)
            .padding(.horizontal, 16)
            .onTapGesture {
                self.viewModel.sendAction(.downloadButtonTap(from: .detail))
            }
        }
        .customToast(toastType: $viewModel.state.showToast)
    }
}

//#Preview {
//    PhotoDetailView()
//}
