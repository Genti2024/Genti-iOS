//
//  PHAssetImageView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI
import Photos

struct PHAssetImageView: View {
    @StateObject private var imageLoader = AssetImageLoader()
    let asset: PHAsset
    
    init(from asset: PHAsset) {
        self.asset = asset
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale = UIScreen.main.scale
            let width = geometry.size.width * scale
            let height = geometry.size.height * scale
            let imageSize = CGSize(width: width, height: height)
            imageViewFromAsset(size: imageSize)
        })
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
        .onChange(of: asset, initial: true) { _, newValue in
            imageLoader.loadImage(for: newValue, size: size)
        }
    }
}

