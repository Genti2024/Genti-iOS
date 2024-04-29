//
//  GeneratorExampleView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI

struct GeneratorExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("예시 사진을 참고해보세요")
                .pretendard(.description)
                .foregroundStyle(.black)
                .padding(.horizontal, 28)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(ExampleImage.mocks, id: \.id) { image in
                        Image(image.imageName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 158)
                    }
                } //:HSTACK
                .padding(.horizontal, 28)
            } //:SCROLL
            .scrollIndicators(.hidden)
        } //:VSTACK
    }
}

#Preview {
    ZStack {
        // Background Color
        Color.backgroundWhite
            .ignoresSafeArea()
        // Content
        VStack {
            GeneratorExampleView()
        }
    } //:ZSTACK

}
