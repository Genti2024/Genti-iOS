//
//  PageType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

enum PageType {
    case onboarding1
    case onboarding2
    case firstGenerator
    case secondGenerator
    case thirdGenerator
    case requestCompleted
    case profile
    case compltedPhoto
    
    var pageName: String {
        switch self {
        case .onboarding1:
            return "onboarding1"
        case .onboarding2:
            return "onboarding2"
        case .firstGenerator:
            return "create1"
        case .secondGenerator:
            return "create2"
        case .thirdGenerator:
            return "create3"
        case .requestCompleted:
            return "picwaiting"
        case .profile:
            return "mypage"
        case .compltedPhoto:
            return "picdone"
        }
    }
}
