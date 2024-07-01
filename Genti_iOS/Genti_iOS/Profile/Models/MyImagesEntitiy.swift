//
//  MyImagesEntitiy.swift
//  Genti
//
//  Created by uiskim on 5/30/24.
//

import Foundation

struct MyImagesEntitiy {
    var isLast: Bool
    var images: [MyImagesEntitiy.Image]
    struct Image: Identifiable, Hashable {
        var id: Int
        var imageURL: String
        var ratio: PhotoRatio
    }
}


