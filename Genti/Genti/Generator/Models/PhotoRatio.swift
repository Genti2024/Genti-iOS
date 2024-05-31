//
//  PhotoRatio.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import Foundation

enum PhotoRatio {
    case twoThird, threeSecond
    
    static var selections: [PhotoRatio] {
        return [.twoThird, .threeSecond]
    }
    
    var image: String {
        switch self {
        case .twoThird:
            return "Ratio_23"
        case .threeSecond:
            return "Ratio_32"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
