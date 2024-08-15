//
//  SignInUserEntity.swift
//  Genti_iOS
//
//  Created by uiskim on 8/15/24.
//

import Foundation

struct SignInUserEntity {
    let email: String
    let socialLoginType: GentiSocialLoginType
    let gender: Gender
    let nickname: String
    let birthYear: Int
}
