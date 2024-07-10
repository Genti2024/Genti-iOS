//
//  UserDefaultsRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

protocol UserDefaultsRepository {
    var isFirstVisit: Bool { get }
}

extension UserDefaultsRepository {
    
    func set<T>(to: T, forKey: UserDefaultsKey) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
    }
    
    func get(forKey: UserDefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
}