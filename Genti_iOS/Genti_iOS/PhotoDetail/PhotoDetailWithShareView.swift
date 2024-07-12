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
        GeometryReader { geometry in
            let padding: CGFloat = 30
            let width = geometry.size.width - (2*padding)
            let height = width * 1.5
            VStack(spacing: 20) {
                Image(uiImage: viewModel.state.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .addDownloadButton {
                        viewModel.sendAction(.downloadButtonTap) }
                    .frame(width: width, height: height)

                
                
                ShareLink(item: Image(uiImage: viewModel.state.image), preview: .init("내 사진", image: Image(uiImage: viewModel.state.image))) {
                    Text("공유하기")
                        .shareStyle()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .addXmark(top: 3, trailing: 20) { viewModel.sendAction(.xmarkTap) }
        .presentationBackground {
            BlurView(style: .systemThinMaterialDark)
        }
    }
}

//#Preview {
//    PhotoDetailWithShareView(viewModel: .init(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: .init(), imageUrlString: ""))
//}
