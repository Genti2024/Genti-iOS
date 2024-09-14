//
//  PhotoDetailWithShareView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct PhotoDetailWithShareView: View {
    @State var viewModel: PhotoDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(.clear)
                .aspectRatio(1/1.5, contentMode: .fit)
                .overlay(alignment: .center) {
                    WebImage(url: URL(string: viewModel.state.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .addDownloadButton { self.viewModel.sendAction(.downloadButtonTap(from: .detailWithShare)) }
                    } placeholder: {
                        Image(uiImage: UIImage(resource: .camera))
                    }
                    .onSuccess { image, _, _ in
                        self.viewModel.sendAction(.imageLoad(image))
                    }
                }
                .padding(.horizontal, 30)
            
            ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                Text("공유하기")
                    .shareStyle()
            }
            .onTapGesture {
                viewModel.sendAction(.shareButtonTap)
            }
            
        }
        .addXmark(top: 3, trailing: 20) {
            viewModel.sendAction(.xmarkTap)
        }
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
