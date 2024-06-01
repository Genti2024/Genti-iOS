//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct PhotoCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPhotoDetail: Bool = false
    var imageName: String = "SampleImage23"
    
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()

            // Content
            
            VStack {
                Image("Genti_LOGO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 44)
                    .padding(.top, 55)
                
                VStack {
                    HStack(spacing: 0) {
                        Text("하나뿐인 나만의 사진")
                            .pretendard(.headline1)
                            .foregroundStyle(.gentiGreen)
                        Text("이")
                            .pretendard(.headline3)
                    }
                    Text("완성되었어요!")
                        .pretendard(.headline3)
                }
                .foregroundStyle(.black)
                .padding(.top, 44)
                
                
                
                Image("Image_frame")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .center) {
                        Rectangle()
                            .overlay(alignment: .center) {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                            .padding(5)
                        
                        
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Image("Download")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .padding(.bottom, 5)
                            .padding(.trailing, 5)
                    }
                    .padding(.horizontal, 58)
                    .onTapGesture {
                        self.showPhotoDetail = true
                    }
                    
                Text("사진이 마이페이지에 저장되었어요!")
                    .pretendard(.normal)
                    .foregroundStyle(.black)
                
                
                Spacer()
                
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
                .padding(.bottom, 28)
                
                Text("메인으로 이동하기")
                    .pretendard(.normal)
                    .foregroundStyle(.gray3)
                    .frame(maxWidth: .infinity)

                    .padding(.vertical, 10)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        self.dismiss()
                    }
                    .padding(.bottom, 30)

                
                Text("혹시 만들려고 했던 사진과 전혀 다른 사진이 나왔나요?")
                    .pretendard(.small)
                    .foregroundStyle(.error)
                    .underline()
                    .padding(.bottom, 30)

                
            }
            
        } //:ZSTACK
        .fullScreenCover(isPresented: $showPhotoDetail) {
            PhotoDetailView(imageName: self.imageName)
        }
    }
}

#Preview {
    PhotoCompleteView(imageName: "SampleImage32")
}
