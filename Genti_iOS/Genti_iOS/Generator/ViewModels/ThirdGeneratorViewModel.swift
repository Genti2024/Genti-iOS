//
//  ThirdGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI
import Photos

@Observable 
final class ThirdGeneratorViewModel: ViewModel, GetImageFromImagePicker {

    struct State {
        var referenceImages: [ImageAsset] = []
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
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
            Task { await completeImageRequest() }
        }
    }
    
    @MainActor
    func completeImageRequest() async {
        do {
            state.isLoading = true
            try await imageGenerateUseCase.requestImage(from: self.requestData())
            NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
            state.isLoading = false
            router.routeTo(.requestCompleted)
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }
    
    let imageGenerateUseCase: ImageGenerateUseCase
    var state: ThirdGeneratorViewModel.State
    var requestImageData: RequestImageData
    var router: Router<MainRoute>
    init(imageGenerateUseCase: ImageGenerateUseCase, requestImageData: RequestImageData, router: Router<MainRoute>) {
        self.imageGenerateUseCase = imageGenerateUseCase
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
}
