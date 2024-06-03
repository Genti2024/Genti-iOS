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
    
    func getReferenceS3Key() async throws -> String {
        if let referencePhAsset = referenceImage?.asset {
            guard let referenceKey = try await APIService.shared.uploadPHAssetToS3(phAsset: referencePhAsset) else {
                throw GentiError.serverError(code: "AWS", message: "referenceImage의 s3key가 null입니다")
            }
            return referenceKey
        }
        return ""
    }
    
    func getFaceS3Keys() async throws -> [String] {
        let facePhAssets = faceImages.map { $0.asset }
        return try await APIService.shared.uploadPHAssetToS3(phAssets: facePhAssets).compactMap{ $0 }
    }

    func generateImage() async throws {

        async let referenceURL = getReferenceS3Key()
        async let facesURLs = getFaceS3Keys()
        
        // 결과 요청 및 처리
        if try await APIService.shared.fetchResponse(for: GeneratorRouter.requestImage(prompt: photoDescription, poseURL: referenceURL, faceURLs: facesURLs, angle: "", coverage: "")) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("GeneratorCompleted"), object: nil)
            }
        }
    }
}
