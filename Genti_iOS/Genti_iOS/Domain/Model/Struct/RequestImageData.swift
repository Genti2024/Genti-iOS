//
//  RequestImageData.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import Foundation

struct RequestImageData {
    var description: String = ""
//    var referenceImageAsset: ImageAsset? = nil
//    var selectedAngle: PhotoAngle? = nil
//    var selectedFrame: PhotoFrame? = nil
    var selectedRatio: PhotoRatio? = nil
    var faceImageAssets: [ImageAsset] = []
    
    mutating func set(description: String) -> Self {
        self.description = description
        return self
    }
    
    mutating func set(ratio: PhotoRatio?) -> Self {
        self.selectedRatio = ratio
        return self
    }
    
    mutating func set(faces: [ImageAsset]) -> Self {
        self.faceImageAssets = faces
        return self
    }
}
