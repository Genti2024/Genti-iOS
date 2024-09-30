//
//  UploadImageType.swift
//  Genti_iOS
//
//  Created by uiskim on 9/30/24.
//


enum UploadImageType {
    case request
    case verify
    
    var bodyValue: String {
        switch self {
        case .request:
            return "USER_UPLOADED_IMAGE"
        case .verify:
            return "USER_VERIFICATION_IMAGE"
        }
    }
}