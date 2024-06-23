//
//  PHAssetImageView.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import SwiftUI
import Photos

struct PHAssetImageView: View {
    @State var viewModel: PHAssetImageViewModel
    var asset: PHAsset
    
    init(viewModel: PHAssetImageViewModel, asset: PHAsset) {
        self.viewModel = viewModel
        self.asset = asset
    }

    var body: some View {
        GeometryReader { geometry in
            let size = calculatedSize(for: geometry)
            imageView(using: size)
                .onAppear {
                    viewModel.sendAction(.viewWillAppear(.init(size: size, asset: asset)))
                }
                .onDisappear {
                    viewModel.sendAction(.viewDidAppear)
                }
        }
        .clipped()
        .contentShape(Rectangle())

    }

    private func imageView(using size: CGSize) -> some View {
        Group {
            if let uiImage = viewModel.state.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }

    private func calculatedSize(for geometry: GeometryProxy) -> CGSize {
        let scale = UIScreen.main.scale * 0.8
        return CGSize(width: geometry.size.width * scale, height: geometry.size.height * scale)
    }
}
