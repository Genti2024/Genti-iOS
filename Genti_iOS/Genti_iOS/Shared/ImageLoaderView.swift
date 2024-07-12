//
//  ImageLoaderView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct ImageLoaderView: View {
    
    var urlString: String
    var resizingMode: ContentMode = .fit
    var ratio: PhotoRatio
    var width: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(.backgroundWhite)
            .frame(width: width)
            .frame(height: width*ratio.ratio)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity(style: .circular))
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}
