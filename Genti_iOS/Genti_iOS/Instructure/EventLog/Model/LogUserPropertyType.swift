//
//  LogUserPropertyType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

enum LogUserPropertyType {
    case userEmail(email: String)
    case userGender(gender: Gender)
    case userBirthYear(birthYear: Int)
    case userLoginType(loginType: GentiSocialLoginType)
    case userNickname(nickname: String)
    case shareButtonTap
    case downloadPhoto
    case scrollMainView
    case refreshMainView
    case createNewPhoto
    case agreePushNotification(isAgree: Bool)
    case verify(isDone: Bool)
    
    var propertyName: String {
        switch self {
        case .userEmail:
            return "user_email"
        case .shareButtonTap:
            return "user_share"
        case .downloadPhoto:
            return "user_picturedownload"
        case .scrollMainView:
            return "user_main_scroll"
        case .refreshMainView:
            return "user_promptsuggest_refresh"
        case .userGender:
            return "user_sex"
        case .userBirthYear:
            return "user_birth_year"
        case .userLoginType:
            return "user_platform"
        case .userNickname:
            return "user_nickname"
        case .createNewPhoto:
            return "user_piccreate"
        case .agreePushNotification:
            return "user_alarm"
        case .verify:
            return "user_verify"
        }
    }
    
    var property: [String: Any]? {
        switch self {
        case .userEmail(let email):
            return ["email": email]
        case .userGender(let gender):
            return ["sex": gender.rawValue]
        case .userBirthYear(let birthYear):
            return ["birthYear": birthYear]
        case .userNickname(let nickname):
            return ["nickname": nickname]
        case .userLoginType(let loginType):
            return ["loginType": loginType.parameter]
        case .agreePushNotification(let agree):
            return ["alarm": agree ? "true" : "false"]
        default:
            return nil
        }
    }
}
