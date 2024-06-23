//
//  horizontalImageContentView.swift
//  Genti_iOS
//
//  Created by uiskim on 6/24/24.
//

import SwiftUI

struct HorizontalImageContentView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.backgroundWhite)
                .clipShape(.rect(cornerRadius: 30))
                .shadow(color: .black.opacity(0.13), radius: 15, y: 4)
                .overlay(alignment: .top) {
                    LinearGradient(colors: [.gradientPurple2, .gentiPurple.opacity(0)], startPoint: .top, endPoint: .bottom)
                        .frame(height: 171)
                }
            // Content
            VStack(spacing: 0) {
                    Image("Genti_LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 44)
                        .padding(.top, 80)
                
                    
                    VStack {
                        HStack(spacing: 0) {
                            Text("하나뿐인 나만의 사진")
                                .pretendard(.headline1)
                                .foregroundStyle(.green1)
                            Text("이")
                                .pretendard(.headline3)
                        }
                        Text("완성되었어요!")
                            .pretendard(.headline3)
                    }
                    .frame(height: 57)
                    .foregroundStyle(.black)
                    .padding(.top, 29)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Image("SampleImage23")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 360)
                        .overlay(alignment: .bottomTrailing) {
                            Image("Download")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .padding(.bottom, 12)
                                .padding(.trailing, 22)
                                .onTapGesture {
                                    print(#fileID, #function, #line, "- downloadtap")
                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(LinearGradient(colors: [.gentiGreen, .gentiGreen.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        )
                        .onTapGesture {
                            print(#fileID, #function, #line, "- imagetap")
                        }
                    
                    Spacer()
                        .frame(height: 18)
                    Text("사진이 마이페이지에 저장되었어요!")
                        .pretendard(.small)
                        .foregroundStyle(.gray3)
                }
        } //:ZSTACK
        .frame(height: 640)
    }
}

#Preview {
    HorizontalImageContentView()
}
