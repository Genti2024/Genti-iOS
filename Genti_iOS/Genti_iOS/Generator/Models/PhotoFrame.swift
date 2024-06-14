//
//  PhotoFrame.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoFrame {
    case face, fullBody, kneeUp, any
    
    static var selections: [PhotoFrame] {
        return [.face, .fullBody, .kneeUp]
    }
    
    var image: String {
        switch self {
        case .face:
            return "Frame_closeup"
        case .fullBody:
            return "Frame_bust"
        case .kneeUp:
            return "Frame_knee"
        case .any:
            return "Check_empty"
        }
    }
    
    var requsetString: String {
        switch self {
        case .face:
            return "FACE"
        case .fullBody:
            return "FULL_BODY"
        case .kneeUp:
            return "KNEE_UP"
        case .any:
            return "ANY"
        }
    }
    
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
    
}
