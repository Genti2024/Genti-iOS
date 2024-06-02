//
//  GeneratorViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

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
    
    @Published var isGenerating: Bool = false
    
    func generateImage() async throws {
        var referenceURL = ""
        var facesURLs: [String] = []
        
        // 참조 이미지 업로드
        if let referencePhAsset = referenceImage?.asset {
            if let referenceS3Key = try await APIService.shared.uploadPHAssetToS3(phAsset: referencePhAsset) {
                referenceURL = referenceS3Key
            }
        }
        
        // 얼굴 이미지 업로드
        let facePhAssets = faceImages.map { $0.asset }
        let referenceS3Keys = try await APIService.shared.uploadPHAssetToS3(phAssets: facePhAssets)
        facesURLs = referenceS3Keys.compactMap { $0 }
        
        // 결과 요청 및 처리
        if try await APIService.shared.fetchResponse(for: GeneratorRouter.requestImage(prompt: photoDescription, poseURL: referenceURL, faceURLs: facesURLs, angle: "", coverage: "")) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("GeneratorCompleted"), object: nil)
            }
        }
    }
}
