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
    
    var requsetString: String {
        switch self {
        case .twoThird:
            return "RATIO_2_3"
        case .threeSecond:
            return "RATIO_3_2"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
