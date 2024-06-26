//
//  HomeFeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct FeedComponent: View {
    
    var mainImage: String
    var description: String
    var ratio: PhotoRatio
    
    var body: some View {
        VStack {
            mainImageView()
            photoDescriptionView()
            detailedDescriptionView()
        }
        .background(Color.green4)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.gentiGreen, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func mainImageView() -> some View {
        ImageLoaderView(urlString: mainImage, ratio: ratio, width: Constants.screenWidth - 32)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gentiGreen, lineWidth: 1)
            )
    }
    private func photoDescriptionView() -> some View {
        HStack {
            Text("사진 설명")
                .pretendard(.number)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    private func detailedDescriptionView() -> some View {
        Text(description)
            .pretendard(.normal)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gentiGreen, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
    }
}
