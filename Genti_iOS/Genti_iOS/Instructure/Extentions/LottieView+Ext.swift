//
//  LottieView+Ext.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import SwiftUI

import Lottie

enum LottieType {
    case splash
    case loading
    
    var rawValue: String {
        switch self {
        case .splash:
            return "SplashLottie"
        case .loading:
            return "ProgressLottie"
        }
    }
}

extension LottieView where Placeholder == EmptyView {
    init(type: LottieType) {
        self.init(animation: .named(type.rawValue))
    }
}
