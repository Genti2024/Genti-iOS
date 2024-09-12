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
                .addDownloadButton { self.viewModel.sendAction(.downloadButtonTap(from: .detail)) }
        } placeholder: {
            Image(uiImage: UIImage(resource: .camera))
        }
        .onSuccess { image, _, _ in
            self.viewModel.sendAction(.imageLoad(image))
        }
        .padding(.horizontal, 28)
        .addXmark(top: 3, trailing: 20) { viewModel.sendAction(.xmarkTap) }
        .customToast(toastType: $viewModel.state.showToast)
        .presentationBackground {
            BlurView(style: .systemUltraThinMaterialDark)
                .onTapGesture {
                    viewModel.sendAction(.backgroundTap)
                }
        }
    }
}

//#Preview {
//    PhotoDetailView()
//}
