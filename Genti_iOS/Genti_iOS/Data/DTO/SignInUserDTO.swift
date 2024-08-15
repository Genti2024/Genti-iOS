//
//  SignInUserDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 8/15/24.
//

import Foundation

struct SignInUserDTO: Codable {
    let email: String
    let lastLoginOauthPlatform: String
    let sex: String
    let nickname: String
    let birthDate: String
}

extension SignInUserDTO {
    func toEntitiy() -> SignInUserEntity? {
        guard let loginType = GentiSocialLoginType(rawValue: self.lastLoginOauthPlatform), let gender = Gender(rawValue: self.sex), let birthYear = Int(self.birthDate) else { return nil }
        return .init(email: self.email, socialLoginType: loginType, gender: gender, nickname: self.nickname, birthYear: birthYear)
    }
}
