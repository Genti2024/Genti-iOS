//
//  ImageView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI
import Photos

struct ImageView: View {
    
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
            PHAssetImageView(asset: asset, size: imageSize)
        })
        .clipped()
        .contentShape(Rectangle())
    }
}

