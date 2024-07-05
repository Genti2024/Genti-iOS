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
                .frame(width: UIScreen.main.bounds.width - 60)
                .frame(height: (UIScreen.main.bounds.width - 60)*1.5)
                .overlay(alignment: .center) {
                    viewModel.getImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(alignment: .trailing) {
                            VStack(alignment: .trailing) {
                                Image("Xmark_empty")
                                    .resizable()
                                    .frame(width: 29, height: 29)
                                    .onTapGesture {
                                        viewModel.sendAction(.xmarkTap)
                                    }
                                
                                Spacer()
                                
                                Image("Download")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .asButton {
                                        viewModel.sendAction(.downloadButtonTap)
                                    }
                                
                            }
                            .padding(.vertical, 4)
                            .padding(.trailing, 4)
                        }
                }
            
            ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                Text("공유하기")
                    .pretendard(.headline1)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(!viewModel.disabled ? .gray4 : .gentiGreen)
                    .overlay(alignment: .leading) {
                        Image("Share")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .padding(.leading, 20)
                    }
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal, 30)
                
            }
            .disabled(!viewModel.disabled)
        }
        .onAppear {
            viewModel.sendAction(.viewWillAppear)
        }
        .presentationBackground {
            BlurView(style: .systemUltraThinMaterialDark)
        }
    }
}

#Preview {
    PhotoDetailWithShareView(viewModel: .init(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: .init(), imageUrlString: ""))
}
