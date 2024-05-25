//
//  PhotoRatio.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import Foundation

enum PhotoRatio {
    case twoThird, threeSecond, free
    
    static var selections: [PhotoRatio] {
        return [.twoThird, .threeSecond]
    }
    
    var image: String {
        switch self {
        case .twoThird:
            return "Ratio_23"
        case .threeSecond:
            return "Ratio_32"
        case .free:
            return "Check_empty"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
