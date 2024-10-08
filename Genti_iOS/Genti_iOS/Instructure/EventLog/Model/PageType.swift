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
    case pushAuthorizationAlert
    case verify1
    case verify2
    
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
        case .pushAuthorizationAlert:
            return "alarmagree"
        case .verify1:
            return "verifyme1"
        case .verify2:
            return "verifyme2"
        }
    }
}
