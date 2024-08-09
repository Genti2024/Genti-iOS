//
//  PhotoFrame.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

enum PhotoFrame {
    case bustShot, kneeShot, fullShot, any
    
    static var selections: [PhotoFrame] {
        return [.bustShot, .kneeShot, .fullShot]
    }
    
    var image: String {
        switch self {
        case .bustShot:
            return "BustShotImage"
        case .kneeShot:
            return "KneeShotImage"
        case .fullShot:
            return "FullShotImage"
        case .any:
            return "Check_empty"
        }
    }
    
    var requsetString: String {
        switch self {
        case .bustShot:
            return "UPPER_BODY"
        case .fullShot:
            return "FULL_BODY"
        case .kneeShot:
            return "KNEE_SHOT"
        case .any:
            return "ANY"
        }
    }
    
    var description: String {
        switch self {
        case .bustShot:
            return "바스트샷\n(상반샷)"
        case .kneeShot:
            return "니샷\n(무릎 위)"
        case .fullShot:
            return "풀샷\n(전신)"
        case .any:
            return ""
        }
    }
    
    
    static var freeSelectedImage: String {
        return "Check_fill"
    }
    
}
