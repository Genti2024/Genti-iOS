//
//  Gender.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import Foundation

enum Gender: String, CaseIterable {
    case boy = "남"
    case girl = "여"
    
    var description: String {
        switch self {
        case .boy:
            return "M"
        case .girl:
            return "W"
        }
    }
    
    var rawValue: String {
        switch self {
        case .boy:
            return "남자"
        case .girl:
            return "여자"
        }
    }
}
