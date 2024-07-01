//
//  PageCommonPictureResponseDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

struct PageCommonPictureResponseDTO: Codable {
    let content: [Content]
    let first, last, empty: Bool
    
    struct Content: Codable {
        let id: Int
        let url: String
        let key, pictureRatio, type: String
        
        var ratio: PhotoRatio {
            if pictureRatio == "RATIO_3_2" {
                return .threeSecond
            }
            return .twoThird
        }
    }
}

extension PageCommonPictureResponseDTO {
    var toEntity: MyImagesEntitiy {
        return .init(isLast: self.last, images: self.content.map{.init(id: $0.id, imageURL: $0.url, ratio: $0.ratio)})
    }
}
