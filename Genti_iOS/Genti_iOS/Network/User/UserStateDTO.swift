//
//  UserStateDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 7/31/24.
//

import Foundation

struct UserStateDTO: Codable {
    let pictureGenerateRequestId: Int?
    let status: String
    let pictureGenerateResponse: PictureGenerateResponse?
    
    struct PictureGenerateResponse: Codable {
        let pictureGenerateResponseId: Int
        let pictureCompleted: PictureCompleted

    }
    
    struct PictureCompleted: Codable {
        let id: Int
        let url: String
        let key, pictureRatio, type: String
    }
}
