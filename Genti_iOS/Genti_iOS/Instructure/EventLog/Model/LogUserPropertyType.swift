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
    case shareButtonTap
    case downloadPhoto
    case scrollMainView
    case refreshMainView
    
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
        case .userBirthYear(birthYear: let birthYear):
            return "user_birthYear"
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
        default:
            return nil
        }
    }
}
