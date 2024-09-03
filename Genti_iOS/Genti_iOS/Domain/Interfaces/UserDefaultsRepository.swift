//
//  UserDefaultsRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

protocol UserDefaultsRepository {
    var isFirstVisitApp: Bool { get }
    var isFirstGenerate: Bool { get }
    func setAccessToken(token: String)
    func setRefreshToken(token: String)
    func setFcmToken(token: String)
    func getToken() -> GentiTokenEntity
    func removeToken()
    func setUserRole(userRole: LoginUserState)
    func getUserRole() -> LoginUserState?
    func removeUserRole()
    func setLoginType(type: GentiSocialLoginType)
    func getLoginType() -> GentiSocialLoginType?
}

extension UserDefaultsRepository {
    
    func set<T>(to: T, forKey: UserDefaultsKey) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
    }
    
    func get(forKey: UserDefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    func remove(forKey: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
}
