//
//  GetUploadImageUrlDTO.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Foundation

struct GetUploadImageUrlDTO: Codable {
    let fileName: String?
    let url: String?
    let s3Key: String?
}
