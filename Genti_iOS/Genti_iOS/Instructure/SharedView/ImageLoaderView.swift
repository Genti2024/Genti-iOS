//
//  ImageLoaderView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

import SDWebImageSwiftUI
import Lottie

struct ImageLoaderView: View {
    
    var urlString: String
    var resizingMode: ContentMode = .fit
    var ratio: PhotoRatio
    
    var body: some View {
        Rectangle()
            .fill(.buttonBackground)
            .aspectRatio(1/ratio.multiplyValue, contentMode: .fill)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.init(content: { _, _ in
                        LottieView(type: .imageLoading)
                            .looping()
                            .frame(width: 80, height: 80)
                    }))
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}
