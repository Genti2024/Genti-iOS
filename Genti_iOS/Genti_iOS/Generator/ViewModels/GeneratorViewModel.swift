//
//  GeneratorViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

protocol GetImageFromAlbum {
    var referenceImages: [ImageAsset] { get set }
    func setReferenceImageAssets(assets: [ImageAsset])
}

struct RequestImageData {
    var description: String = ""
    var referenceImageAsset: ImageAsset? = nil
    var selectedAngle: PhotoAngle? = nil
    var selectedFrame: PhotoFrame? = nil
    var selectedRatio: PhotoRatio? = nil
    var faceImageAssets: [ImageAsset] = []
    
    mutating func set(description: String, reference: ImageAsset?) -> Self {
        self.description = description
        self.referenceImageAsset = reference
        return self
    }
    
    mutating func set(angle: PhotoAngle?, frame: PhotoFrame?, ratio: PhotoRatio?) -> Self {
        self.selectedAngle = angle
        self.selectedFrame = frame
        self.selectedRatio = ratio
        return self
    }
    
    mutating func set(faces: [ImageAsset]) -> Self {
        self.faceImageAssets = faces
        return self
    }
}

@Observable final class FirstGeneratorViewModel: GetImageFromAlbum {
    // firstView
    private var currentIndex: Int = -1
    private let randomDescription: [String] = [
        "프랑스 야경을 즐기는 모습을 그려주세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.1",
        "프랑스 야경을 즐기는 모습을 그려주세모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요.2",
        "프랑스 야경을 즐기는 모습을 그려. 항공점퍼를 입고주세요. 항공점퍼를 입고. 항공점퍼를 입고 테라스에 서 있는 모습이에요.3",
        "프랑스 야경을 즐기는 모습을 그려주모습을 그려주세요. 항공점퍼를 입고 테라스세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.4",
    ]
    
    var referenceImages: [ImageAsset] = []
    
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.referenceImages = assets
    }
    
    func removeReferenceImage() {
        self.referenceImages = []
    }

    var photoDescription: String = ""
    var currentRandomDescriptionExample: String = ""
    
    func getRandomDescriptionExample() {
        currentIndex = (currentIndex + 1) % randomDescription.count
        self.currentRandomDescriptionExample = randomDescription[currentIndex]
    }
    
    var descriptionIsEmpty: Bool {
        return photoDescription.isEmpty
    }
    
    func requestData() -> RequestImageData {
        var requestImageData = RequestImageData()
        if referenceImages.isEmpty {
            return requestImageData.set(description: self.photoDescription, reference: nil)
        } else {
            return requestImageData.set(description: self.photoDescription, reference: referenceImages[0])
            
        }
    }
}

@Observable final class SecondGeneratorViewModel {
    
    var requestImageData: RequestImageData
    
    init(requestImageData: RequestImageData) {
        self.requestImageData = requestImageData
    }
    
    var selectedAngle: PhotoAngle? = nil
    var selectedFrame: PhotoFrame? = nil
    var selectedRatio: PhotoRatio? = nil
    
    var angleOrFrameOrRatioIsEmpty: Bool {
        return selectedAngle == nil || selectedFrame == nil || selectedRatio == nil
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(angle: self.selectedAngle,
                               frame: self.selectedFrame,
                               ratio: self.selectedRatio)
    }
}

@Observable final class ThirdGeneratorViewModel: GetImageFromAlbum {
    
    var requestImageData: RequestImageData
    
    init(requestImageData: RequestImageData) {
        self.requestImageData = requestImageData
    }
    
    var referenceImages: [ImageAsset] = []
    
    var facesIsEmpty: Bool {
        return referenceImages.isEmpty
    }
    
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.referenceImages = assets
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(faces: referenceImages)
    }
    
    func getReferenceS3Key(imageAsset: ImageAsset?) async throws -> String? {
        if let referencePhAsset = imageAsset?.asset {
            guard let referenceKey = try await APIService.shared.uploadPHAssetToS3(phAsset: referencePhAsset) else {
                throw GentiError.serverError(code: "AWS", message: "referenceImage의 s3key가 null입니다")
            }
            return referenceKey
        }
        return nil
    }
    
    func getFaceS3Keys(imageAssets: [ImageAsset]) async throws -> [String] {
        return try await APIService.shared.uploadPHAssetToS3(phAssets: imageAssets.map { $0.asset }).compactMap{ $0 }
    }

    func generateImage() async throws {
        let request = self.requestData()
        async let referenceURL = getReferenceS3Key(imageAsset: request.referenceImageAsset)
        async let facesURLs = getFaceS3Keys(imageAssets: request.faceImageAssets)
        
        guard let selectedAngle = request.selectedAngle, let selectedFrame = request.selectedFrame, let selectedRatio = request.selectedRatio else {
            throw GentiError.clientError(code: "Unwrapping", message: "각도,프레임,비율의 값이 비어있습니다")
        }
        
        let _: Bool = try await APIService.shared.fetchResponse(for: GeneratorRouter.requestImage(prompt: request.description, poseURL: referenceURL, faceURLs: facesURLs, angle: selectedAngle, coverage: selectedFrame, ratio: selectedRatio))
    }
}
