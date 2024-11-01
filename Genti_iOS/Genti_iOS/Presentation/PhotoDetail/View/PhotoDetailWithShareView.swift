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
                .aspectRatio(1/1.5, contentMode: .fit)
                .overlay(alignment: .center) {
                    WebImage(url: URL(string: viewModel.state.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(uiImage: UIImage(resource: .camera))
                    }
                    .onSuccess { image, _, _ in
                        self.viewModel.sendAction(.imageLoad(image))
                    }
                }
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            HStack {
                ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                    Text("공유하기")
                        .pretendard(.subtitle2_16_bold)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.geintiBackground)
                        .background(LinearGradient.gentiGradation)
                        .cornerRadius(10, corners: .allCorners)
                }
                .onTapGesture {
                    viewModel.sendAction(.shareButtonTap)
                }
                
                Text("저장하기")
                    .pretendard(.subtitle2_16_bold)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .foregroundStyle(.geintiBackground)
                    .cornerRadius(10, corners: .allCorners)
                    .onTapGesture {
                        self.viewModel.sendAction(.downloadButtonTap(from: .detailWithShare))
                    }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 1)

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
