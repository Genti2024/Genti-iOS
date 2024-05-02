//
//  PHAssetImageView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI
import Photos
import Combine

struct PHAssetImageView: View {
    @StateObject private var imageLoader = AssetImageLoader()
    @State var asset: PHAsset
    
    var body: some View {
        GeometryReader { geometry in
            let scale = UIScreen.main.scale * 0.8
            let imageSize = CGSize(width: geometry.size.width * scale, height: geometry.size.height * scale)
            imageViewFromAsset(size: imageSize)
        }
        .clipped()
        .contentShape(Rectangle())
    }
    
    func imageViewFromAsset(size: CGSize) -> some View {
        Group {
            if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Text("Loading...")
                    .pretendard(.description)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear {
            imageLoader.loadImage(for: asset, size: size)
        }
    }
}

