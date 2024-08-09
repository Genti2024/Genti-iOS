//
//  PageCommonPictureResponseDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

struct PageCommonPictureResponseDTO: Codable {
    let id: Int
    let url: String
    let pictureRatio: String
    
    var ratio: PhotoRatio {
        if pictureRatio == "RATIO_3_2" {
            return .threeSecond
        }
        return .twoThird
    }
}

extension PageCommonPictureResponseDTO {
    var toEntity: MyImagesEntitiy {
        return .init(id: self.id, imageURL: self.url, ratio: self.ratio)
    }
}
