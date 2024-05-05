//
//  GeneratorViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI

final class GeneratorViewModel: ObservableObject {

    // firstView
    @Published var referenceImage: ImageAsset? = nil
    @Published var showPhotoPickerWhenFirstView: Bool = false
    @Published var photoDescription: String = ""
    
    var descriptionIsEmpty: Bool {
        return !photoDescription.isEmpty
    }

    func setReferenceImageAsset(asset: ImageAsset) {
        self.referenceImage = asset
    }
    
    func removeReferenceImage() {
        self.referenceImage = nil
    }
    
    // secondView
    @Published var selectedAngle: PhotoAngle? = nil
    @Published var selectedFrame: PhotoFrame? = nil
    
    var angleAndFrameSelected: Bool {
        return selectedAngle != nil && selectedFrame != nil
    }
    
    // thirdView
    @Published var showPhotoPickerWhenThirdView: Bool = false
    @Published var faceImages: [ImageAsset] = []
    
    var faceImagesIsEmpty: Bool {
        return faceImages.isEmpty
    }
    
    func setFaceImageAssets(assets: [ImageAsset]) {
        self.faceImages = assets
    }
}
