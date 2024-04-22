//
//  PhotoAngle.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoAngle {
    case top, center, bottom, free
    
    static var selections: [PhotoAngle] {
        return [.top, .center, .bottom]
    }
    
    var image: String {
        switch self {
        case .top:
            return "Angle_top"
        case .center:
            return "Angle_center"
        case .bottom:
            return "Angle_bottom"
        case .free:
            return "Check_empty"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
}
