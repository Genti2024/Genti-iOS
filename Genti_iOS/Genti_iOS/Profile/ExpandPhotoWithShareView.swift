//
//  PostDetailView.swift
//  Genti
//
//  Created by uiskim on 5/30/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct ExpandPhotoWithShareView: View {
    @Bindable var router: Router<MainRoute>

    let imageUrl: String

    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(.clear)
                .frame(width: UIScreen.main.bounds.width - 60)
                .frame(height: (UIScreen.main.bounds.width - 60)*1.5)
                .overlay(alignment: .center) {
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(alignment: .trailing) {
                            VStack(alignment: .trailing) {
                                Image("Xmark_empty")
                                    .resizable()
                                    .frame(width: 29, height: 29)
                                    .onTapGesture {
                                        router.dismissSheet()
                                    }
                                
                                Spacer()
                                
                                Image("Download")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                
                            }
                            .padding(.vertical, 4)
                            .padding(.trailing, 4)
                        }
                }
            
            Button {
                // Action
            } label: {
                Text("공유하기")
                    .pretendard(.headline1)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.gentiGreen)
                    .overlay(alignment: .leading) {
                        Image("Share")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .padding(.leading, 20)
                    }
                    .clipShape(.rect(cornerRadius: 10))
            }
            .padding(.horizontal, 30)

        }

        .presentationBackground {
            BlurView(style: .systemUltraThinMaterialDark)
        }

    }
}

#Preview {
    ExpandPhotoWithShareView(router: .init(), imageUrl: "SampleImage23")
}
