//
//  HomeFeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct FeedComponent: View {
    
    var imageUrl: String
    var description: String
    var ratio: PhotoRatio
    
    var body: some View {
        VStack {
            mainImageView()
            photoDescriptionView()
        }
        .background(Color.buttonBackground)
        .cornerRadius(10, corners: .allCorners)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func mainImageView() -> some View {
        ImageLoaderView(urlString: imageUrl, ratio: ratio)
            .cornerRadius(6, corners: .allCorners)
    }
    private func photoDescriptionView() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("사진 설명")
                    .pretendard(.body_14_medium)
                    .foregroundStyle(.white.opacity(0.4))
                
                Spacer()
            }

            HStack {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .pretendard(.body_14_medium)
                    .foregroundStyle(.white.opacity(0.8))
                Spacer()
            }

        }
        .padding(16)
    }
}
