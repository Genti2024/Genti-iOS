//
//  FeedView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct FeedView: View {
    
    var mainImage: String = "SampleImage32"
    var description: String = Constants.text(length: 200)
    
    var body: some View {
        VStack {
            Image(mainImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gentiGreen, lineWidth: 1)
                )
            
            HStack(spacing: 0) {
                Text("사진 설명")
                    .pretendard(.number)
                    .foregroundStyle(.black)
                Spacer()
            } //:HSTACK
            .padding(.horizontal, 10)

            
            
            Text(description)
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gentiGreen, lineWidth: 1)
                )
            
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            
        } //: VStack
        .background(.green4)
        .clipShape(.rect(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.gentiGreen, style: .init(lineWidth: 1))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}


#Preview {
    ScrollView {
        FeedView(description: Constants.text(length: 50))
        FeedView(description: Constants.text(length: 100))
        FeedView(mainImage: "SampleImage32", description: Constants.text(length: 200))
        FeedView(description: Constants.text(length: 100))
        FeedView(description: Constants.text(length: 100))
    }
}
