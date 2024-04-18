//
//  FirstGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct FirstGeneratorView: View {

    var onXmarkPressed: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                // Content
                VStack {
                    Text("사진생성첫번째뷰입니다")
                    NavigationLink {
                        SecondGeneratorView(onXmarkPressed: onXmarkPressed)
                    } label: {
                        Text("다음뷰로 넘어갑시다")
                    }

                    Button {
                        // Action
                        onXmarkPressed?()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding()
                } //:VSTACK
            } //:ZSTACK
        }


    }
}

#Preview {
    FirstGeneratorView()
}
