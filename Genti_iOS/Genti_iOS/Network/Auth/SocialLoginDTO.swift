//
//  SocialLoginDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

struct SocialLoginDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let userRoleString: String
    
    var userStatus: LoginUserState {
        switch userRoleString {
        case "OAUTH_FIRST_JOIN":
            return .notComplete
        case "USER":
            return .complete
        default:
            return .notComplete
        }
    }
}

extension SocialLoginDTO {
    var toEntity: SocialLoginEntity {
        return .init(accessToken: self.accessToken, refreshToken: self.refreshToken, userStatus: self.userStatus)
    }
}
