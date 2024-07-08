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
        viewModel.getImage
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
            .addXmark { viewModel.sendAction(.xmarkTap) } 
            .presentationBackground {
                BlurView(style: .systemUltraThinMaterialDark)
                    .onTapGesture {
                        print(#fileID, #function, #line, "- 배경터치했습니다")
                    }
            }
            .onAppear {
                self.viewModel.sendAction(.viewWillAppear)
            }
    }
}

//#Preview {
//    PhotoDetailView()
//}
