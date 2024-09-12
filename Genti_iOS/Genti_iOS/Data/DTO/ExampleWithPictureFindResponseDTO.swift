//
//  ExampleWithPictureFindResponseDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 6/30/24.
//

import Foundation

struct ExampleWithPictureFindResponseDTO: Codable {
    let picture: Picture
    let prompt: String
    
    struct Picture: Codable {
        let id: Int
        let url: String
        let key, pictureRatio, type: String
    }
}

extension ExampleWithPictureFindResponseDTO {
    var toEntity: FeedEntity {
        return .init(id: self.picture.id, imageUrl: self.picture.url, description: self.prompt, ratio: self.ratio)
    }
    
    var ratio: PhotoRatio {
        if self.picture.pictureRatio == "RATIO_SERO" {
            return .sero
        }
        return .garo
    }
}
