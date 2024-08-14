//
//  PhotoDetailWithShareView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import SwiftUI

struct PhotoDetailWithShareView: View {
    @State var viewModel: PhotoDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(.clear)
                .aspectRatio(1/1.5, contentMode: .fit)
                .overlay(alignment: .center) {
                    Image(uiImage: viewModel.state.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .addDownloadButton {
                            viewModel.sendAction(.downloadButtonTap) }
                }
                .padding(.horizontal, 30)
            
            ShareLink(item: Image(uiImage: viewModel.state.image), preview: .init("내 사진", image: Image(uiImage: viewModel.state.image))) {
                Text("공유하기")
                    .shareStyle()
            }
            .onTapGesture {
                viewModel.sendAction(.shareButtonTap)
            }
            
        }
        .addXmark(top: 3, trailing: 20) { viewModel.sendAction(.xmarkTap) }
        .customToast(toastType: $viewModel.state.showToast)
        .presentationBackground {
            BlurView(style: .systemThinMaterialDark)
                .onTapGesture {
                    viewModel.sendAction(.backgroundTap)
                }
        }
    }
}

//#Preview {
//    PhotoDetailWithShareView(viewModel: .init(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: .init(), imageUrlString: ""))
//}
