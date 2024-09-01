//
//  UserDefaultsRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

struct UserDefaultsRepositoryImpl: UserDefaultsRepository {
    func setLoginType(type: GentiSocialLoginType) {
        self.set(to: type.rawValue, forKey: .loginType)
    }
    
    func getLoginType() -> GentiSocialLoginType? {
        guard let loginTypeRawValue = self.get(forKey: .loginType) as? String, let loginType = GentiSocialLoginType(rawValue: loginTypeRawValue) else {
            return nil
        }
        return loginType
    }
    
    func getUserRole() -> LoginUserState? {
        guard let userRoleRawValue = self.get(forKey: .userRole) as? String, let userRole = LoginUserState(rawValue: userRoleRawValue) else {
            return nil
        }
        return userRole
    }
    
    func setUserRole(userRole: LoginUserState) {
        self.set(to: userRole.rawValue, forKey: .userRole)
    }
    
    
    func getToken() -> GentiTokenEntity {
        guard let accessToken = self.get(forKey: .accessToken) as? String, let refreshToken = self.get(forKey: .refreshToken) as? String, let fcmToken = self.get(forKey: .fcmToken) as? String else {
            return .init(accessToken: nil, refreshToken: nil, fcmToken: nil)
        }
        return .init(accessToken: accessToken, refreshToken: refreshToken, fcmToken: fcmToken)
    }
    
    func setAccessToken(token: String) {
        self.set(to: token, forKey: .accessToken)
    }
    
    func setRefreshToken(token: String) {
        self.set(to: token, forKey: .refreshToken)
    }
    
    func setFcmToken(token: String) {
        self.set(to: token, forKey: .fcmToken)
    }
    
    func removeToken() {
        self.remove(forKey: .accessToken)
        self.remove(forKey: .refreshToken)
    }
    
    func removeUserRole() {
        self.remove(forKey: .userRole)
    }
    
    var isFirstGenerate: Bool {
        guard let isFirstGenerate = self.get(forKey: .isFirstGenerate) as? Bool else {
            self.set(to: false, forKey: .isFirstGenerate)
            return true
        }
        return isFirstGenerate
    }
    
    var isFirstVisitApp: Bool {
        guard let isFirstVisitApp = self.get(forKey: .isFirstVisitApp) as? Bool else {
            self.set(to: false, forKey: .isFirstVisitApp)
            return true
        }
        return isFirstVisitApp
    }
}
