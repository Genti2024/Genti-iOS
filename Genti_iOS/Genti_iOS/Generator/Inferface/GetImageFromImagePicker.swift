//
//  GetImageFromImagePicker.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import Foundation

protocol GetImageFromImagePicker: AnyObject {
    var referenceImages: [ImageAsset] { get set }
    func setReferenceImageAssets(assets: [ImageAsset])
}

extension GetImageFromImagePicker {  
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.referenceImages = assets
    }
}
