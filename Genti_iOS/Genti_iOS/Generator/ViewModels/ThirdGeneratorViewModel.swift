//
//  ThirdGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI

@Observable 
final class ThirdGeneratorViewModel: ViewModel, GetImageFromImagePicker {

    
    struct State {
        var referenceImages: [ImageAsset] = []
        var isLoading: Bool = false
    }
    
    enum Input {
        case addImageButtonTap
        case backButtonTap
        case xmarkTap
        case nextButtonTap
        case reChoiceButtonTap
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .addImageButtonTap, .reChoiceButtonTap:
            router.routeTo(.imagePicker(limitCount: 3, viewModel: self))
        case .backButtonTap:
            router.dismiss()
        case .xmarkTap:
            router.dismissSheet()
        case .nextButtonTap:
            Task {
                do {
                    state.isLoading = true
                    try await generateImage()
                    state.isLoading = false
                    router.routeTo(.requestCompleted)
                } catch(let error) {
                    print(error as! GentiError)
                }
            }
        }
    }
    
    var state: ThirdGeneratorViewModel.State
    
    
    var requestImageData: RequestImageData
    var router: Router<MainRoute>
    init(requestImageData: RequestImageData, router: Router<MainRoute>) {
        self.requestImageData = requestImageData
        self.router = router
        self.state = .init()
    }
    
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.state.referenceImages = assets
    }
    
    var facesIsEmpty: Bool {
        return state.referenceImages.isEmpty
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(faces: state.referenceImages)
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

