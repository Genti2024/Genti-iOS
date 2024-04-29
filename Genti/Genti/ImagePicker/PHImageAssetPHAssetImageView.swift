//
//  PHImageAssetView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos
import PhotosUI

struct PHAssetImageView: View {
    @StateObject private var imageLoader = AssetImageLoader()
    let asset: PHAsset
    let size: CGSize
    
    var body: some View {
        Group {
            if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Text("Loading")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onChange(of: asset, initial: true) { _, newValue in
            imageLoader.loadImage(for: newValue, size: size)
        }
    }
}
