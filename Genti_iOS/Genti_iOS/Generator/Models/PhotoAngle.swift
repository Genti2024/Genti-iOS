//
//  PhotoAngle.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoAngle {
    case high, middle, low, any
    
    static var selections: [PhotoAngle] {
        return [.high, .middle, .low]
    }
    
    var image: String {
        switch self {
        case .high:
            return "Angle_top"
        case .middle:
            return "Angle_center"
        case .low:
            return "Angle_bottom"
        case .any:
            return "Check_empty"
        }
    }
    
    var requsetString: String {
        switch self {
        case .high:
            return "HIGH"
        case .middle:
            return "MIDDLE"
        case .low:
            return "LOW"
        case .any:
            return "ANY"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
