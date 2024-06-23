//
//  UploadService.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation

protocol UploadService {
    func upload(s3Key: String?, imageData: Data, presignedURLString: String?) async throws -> String?
}
