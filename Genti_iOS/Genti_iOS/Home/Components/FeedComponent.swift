//
//  HomeFeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct FeedComponent: View {
    
    var mainImage: String = "SampleImage32"
    var description: String = Constants.text(length: 200)
    
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
        Image(mainImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
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

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedComponent()
    }
}

#Preview {
    ScrollView {
        FeedComponent(description: Constants.text(length: 200))
        FeedComponent(description: Constants.text(length: 200))
        FeedComponent(mainImage: "SampleImage32", description: Constants.text(length: 200))
        FeedComponent(description: Constants.text(length: 200))
        FeedComponent(description: Constants.text(length: 100))
    }
}
