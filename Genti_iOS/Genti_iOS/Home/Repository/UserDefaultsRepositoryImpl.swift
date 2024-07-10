//
//  UserDefaultsRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/10/24.
//

import Foundation

struct UserDefaultsRepositoryImpl: UserDefaultsRepository {
    var isFirstVisit: Bool {
        guard let isFirst = self.get(forKey: .isFirst) as? Bool else {
            self.set(to: false, forKey: .isFirst)
            return true
        }
        return isFirst
    }
}
