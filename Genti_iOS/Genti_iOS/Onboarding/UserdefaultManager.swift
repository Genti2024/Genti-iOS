//
//  UserdefaultManager.swift
//  Genti_iOS
//
//  Created by uiskim on 7/9/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case isFirst
}

protocol UserDefaultsRepository {
    func set<T>(to: T, forKey: UserDefaultsKeys)
    func get(forKey: UserDefaultsKeys) -> Any?
}

struct UserDefaultsRepositoryImpl: UserDefaultsRepository {

    func set<T>(to: T, forKey: UserDefaultsKeys) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
    }
    
    func get(forKey: UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
}
