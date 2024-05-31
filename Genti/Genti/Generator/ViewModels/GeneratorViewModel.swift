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
        return photoDescription.isEmpty
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
    @Published var selectedRatio: PhotoRatio? = nil
    
    var angleOrFrameOrRatioIsEmpty: Bool {
        return selectedAngle == nil || selectedFrame == nil || selectedRatio == nil
    }
    
    // thirdView
    @Published var showPhotoPickerWhenThirdView: Bool = false
    @Published var faceImages: [ImageAsset] = []
    
    var facesIsEmpty: Bool {
        return faceImages.isEmpty
    }
    
    func setFaceImageAssets(assets: [ImageAsset]) {
        self.faceImages = assets
    }
    
    func resetFirst() {
        self.referenceImage = nil
        self.showPhotoPickerWhenFirstView  = false
        self.photoDescription = ""
    }
    
    func resetSecond() {
        self.selectedAngle = nil
        self.selectedFrame = nil
        self.selectedRatio = nil
    }
    
    func resetThird() {
        self.showPhotoPickerWhenThirdView = false
        self.faceImages = []
    }
    
    func reset() {
        resetFirst()
        resetSecond()
        resetThird()
    }
}
