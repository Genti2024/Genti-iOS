//
//  PhotoAngle.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoAngle {
    case above, eyeLevel, below, any
    
    static var selections: [PhotoAngle] {
        return [.above, .eyeLevel, .below]
    }
    
    var image: String {
        switch self {
        case .above:
            return "Angle_top"
        case .eyeLevel:
            return "Angle_center"
        case .below:
            return "Angle_bottom"
        case .any:
            return "Check_empty"
        }
    }
    
    var requsetString: String {
        switch self {
        case .above:
            return "ABOVE"
        case .eyeLevel:
            return "EYE_LEVEL"
        case .below:
            return "BELOW"
        case .any:
            return "ANY"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
