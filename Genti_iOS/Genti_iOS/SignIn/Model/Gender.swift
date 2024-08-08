//
//  Gender.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import Foundation

enum Gender: CaseIterable {
    case boy, girl
    
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
