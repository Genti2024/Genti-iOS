//
//  PhotoDetailView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import SwiftUI

struct PhotoDetailView: View {

    let viewModel: PhotoDetailViewModel
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Image(uiImage: viewModel.state.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .bottomTrailing) {
                Image("Download")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .asButton {
                        self.viewModel.sendAction(.downloadButtonTap)
                    }
            }
            .padding(.horizontal, 28)
            .addXmark(top: 3, trailing: 20) { viewModel.sendAction(.xmarkTap) }
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
