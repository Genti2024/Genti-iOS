//
//  GentiSocialLoginType.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

enum GentiSocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    var parameter: String {
        switch self {
        case .kakao:
            return "KAKAO"
        case .apple:
            return "APPLE"
        }
    }
}
