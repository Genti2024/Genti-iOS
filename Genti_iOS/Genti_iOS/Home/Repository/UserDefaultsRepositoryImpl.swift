//
//  UserDefaultsRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

struct UserDefaultsRepositoryImpl: UserDefaultsRepository {
    
    func getToken() -> GentiTokenEntity {
        guard let accessToken = self.get(forKey: .accessToken) as? String, let refreshToken = self.get(forKey: .refreshToken) as? String else {
            return .init(accessToken: nil, refreshToken: nil)
        }
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func setToken(token: GentiTokenEntity) {
        self.set(to: token.accessToken, forKey: .accessToken)
        self.set(to: token.refreshToken, forKey: .refreshToken)
    }
    
    func removeToken() {
        self.remove(forKey: .accessToken)
        self.remove(forKey: .refreshToken)
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
