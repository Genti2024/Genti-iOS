//
//  GeneratorViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

@Observable final class GeneratorViewModel {

    // firstView
    private var currentIndex: Int = -1
    private let randomDescription: [String] = [
        "프랑스 야경을 즐기는 모습을 그려주세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.1",
        "프랑스 야경을 즐기는 모습을 그려주세모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요.2",
        "프랑스 야경을 즐기는 모습을 그려. 항공점퍼를 입고주세요. 항공점퍼를 입고. 항공점퍼를 입고 테라스에 서 있는 모습이에요.3",
        "프랑스 야경을 즐기는 모습을 그려주모습을 그려주세요. 항공점퍼를 입고 테라스세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.4",
    ]
    
    var referenceImage: ImageAsset? = nil
    var showPhotoPickerWhenFirstView: Bool = false
    var photoDescription: String = ""
    var currentRandomDescriptionExample: String = ""
    
    func getRandomDescriptionExample() {
        currentIndex = (currentIndex + 1) % randomDescription.count
        self.currentRandomDescriptionExample = randomDescription[currentIndex]
    }
    
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
    var selectedAngle: PhotoAngle? = nil
    var selectedFrame: PhotoFrame? = nil
    var selectedRatio: PhotoRatio? = nil
    
    var angleOrFrameOrRatioIsEmpty: Bool {
        return selectedAngle == nil || selectedFrame == nil || selectedRatio == nil
    }
    
    // thirdView
    var showPhotoPickerWhenThirdView: Bool = false
    var faceImages: [ImageAsset] = []
    
    var facesIsEmpty: Bool {
        return faceImages.isEmpty
    }
    
    func setFaceImageAssets(assets: [ImageAsset]) {
        self.faceImages = assets
    }
    
    // navigation
//    var generatorPath: [GeneratorFlow] = []
//    
//    func push(_ flow: GeneratorFlow) {
//        self.generatorPath.append(flow)
//    }
//    
//    func back() {
//        let removeLast = self.generatorPath.removeLast()
//        if removeLast == .second {
//            self.resetSecond()
//        } else if removeLast == .thrid {
//            self.resetThird()
//        }
//    }
    
//    func resetFirst() {
//        self.referenceImage = nil
//        self.showPhotoPickerWhenFirstView  = false
//        self.photoDescription = ""
//    }
//    
//    func resetSecond() {
//        self.selectedAngle = nil
//        self.selectedFrame = nil
//        self.selectedRatio = nil
//    }
//    
//    func resetThird() {
//        self.showPhotoPickerWhenThirdView = false
//        self.faceImages = []
//    }
//    
//    func reset() {
//        resetFirst()
//        resetSecond()
//        resetThird()
//    }
//    
    
    // request
    var isGenerating: Bool = false
    var generateCompleted: Bool = false
    
    func getReferenceS3Key() async throws -> String? {
        if let referencePhAsset = referenceImage?.asset {
            guard let referenceKey = try await APIService.shared.uploadPHAssetToS3(phAsset: referencePhAsset) else {
                throw GentiError.serverError(code: "AWS", message: "referenceImage의 s3key가 null입니다")
            }
            return referenceKey
        }
        return nil
    }
    
    func getFaceS3Keys() async throws -> [String] {
        let facePhAssets = faceImages.map { $0.asset }
        return try await APIService.shared.uploadPHAssetToS3(phAssets: facePhAssets).compactMap{ $0 }
    }

    func generateImage() async throws -> Bool {

        async let referenceURL = getReferenceS3Key()
        async let facesURLs = getFaceS3Keys()
        
        return try await APIService.shared.fetchResponse(for: GeneratorRouter.requestImage(prompt: photoDescription, poseURL: referenceURL, faceURLs: facesURLs, angle: selectedAngle!, coverage: selectedFrame!, ratio: selectedRatio!))
    }
}