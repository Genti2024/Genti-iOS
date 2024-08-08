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
    
    var body: some View {
        Rectangle()
            .fill(.backgroundWhite)
            .aspectRatio(1/ratio.ratio, contentMode: .fill)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity(style: .circular))
                    .tint(.gentiGreen)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}
