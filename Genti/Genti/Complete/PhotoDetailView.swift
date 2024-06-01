//
//  PhotoDetailView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var imageName: String = "SampleImage23"
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .bottomTrailing) {
                Image("Download")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .overlay(alignment: .topTrailing) {
                Image("Xmark_empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 29, height: 29)
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    .onTapGesture {
                        self.dismiss()
                    }
            }
            .padding(.horizontal, 28)
            .presentationBackground {
                BlurView(style: .systemUltraThinMaterialDark)
                    .onTapGesture {
                        self.dismiss()
                    }
            }
    }

}

#Preview {
    PhotoDetailView()
}
