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
    
    var pageName: String {
        switch self {
        case .detail:
            return "picdone"
        case .detailWithShare:
            return "mypage"
        }
    }
}
