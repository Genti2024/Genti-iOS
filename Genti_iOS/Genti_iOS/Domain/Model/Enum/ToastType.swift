//
//  ToastType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/5/24.
//

import Foundation

enum ToastType {
    case success
    case failure
    
    var message: String {
        switch self {
        case .success:
            return "다운로드에 성공했습니다"
        case .failure:
            return "다운로드에 실패했습니다"
        }
    }
}
