//
//  PhotoFrame.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoFrame {
    case closeUp, bust, knee, full, free
    
    static var selections: [PhotoFrame] {
        return [.closeUp, .bust, .knee, .full]
    }
    
    var image: String {
        switch self {
        case .closeUp:
            return "Frame_closeup"
        case .bust:
            return "Frame_bust"
        case .knee:
            return "Frame_knee"
        case .full:
            return "Frame_full"
        case .free:
            return "Check_empty"
        }
    }
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
    
}
