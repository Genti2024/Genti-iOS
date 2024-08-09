//
//  PhotoRatio.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import Foundation

enum PhotoRatio {
    case garo, sero, square
    
    static var selections: [PhotoRatio] {
        return [.sero, .garo]
    }
    
    var multiplyValue: CGFloat {
        switch self {
        case .garo:
            return 2/3
        case .sero:
            return 3/2
        case .square:
            return 1
        }
    }
    
    var image: String {
        switch self {
        case .garo:
            return "Ratio_garo"
        case .sero:
            return "Ratio_sero"
        case .square:
            return ""
        }
    }
    
    var requsetString: String {
        switch self {
        case .garo:
            return "RATIO_GARO"
        case .sero:
            return "RATIO_SERO"
        case .square:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .garo:
            "2:3 비율\n(가로로 긴 사진)"
        case .sero:
            "3:2 비율\n(세로로 긴 사진)"
        case .square:
            ""
        }
    }
    
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
