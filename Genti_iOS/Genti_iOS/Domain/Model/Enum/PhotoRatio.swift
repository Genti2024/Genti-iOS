//
//  PhotoRatio.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import Foundation

enum PhotoRatio {
    case twoThird, threeSecond, square
    
    static var selections: [PhotoRatio] {
        return [.threeSecond, .twoThird]
    }
    
    var ratio: CGFloat {
        switch self {
        case .twoThird:
            return 3/2
        case .threeSecond:
            return 2/3
        case .square:
            return 1
        }
    }
    
    var image: String {
        switch self {
        case .twoThird:
            return "Ratio_23"
        case .threeSecond:
            return "Ratio_32"
        case .square:
            return ""
        }
    }
    
    var requsetString: String {
        switch self {
        case .twoThird:
            return "RATIO_2_3"
        case .threeSecond:
            return "RATIO_3_2"
        case .square:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .twoThird:
            "2:3 비율\n(가로로 긴 사진)"
        case .threeSecond:
            "3:2 비율\n(세로로 긴 사진)"
        case .square:
            ""
        }
    }
    
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}