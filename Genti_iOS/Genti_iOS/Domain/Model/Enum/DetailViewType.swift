//
//  DetailViewType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

enum DetailViewType {
    case detail
    case detailWithShare
    
    var initalPage: PageType {
        switch self {
        case .detail:
            return .compltedPhoto
        case .detailWithShare:
            return .profile
        }
    }
}
