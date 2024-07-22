//
//  UserDefaultsRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

struct UserDefaultsRepositoryImpl: UserDefaultsRepository {
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
