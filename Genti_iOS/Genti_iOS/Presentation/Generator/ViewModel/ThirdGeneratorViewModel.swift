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
        case .addImageButtonTap:
            EventLogManager.shared.logEvent(.clickButton(page: .thirdGenerator, buttonName: "selectpic"))
            showImagePicker()
        case .reChoiceButtonTap:
            EventLogManager.shared.logEvent(.clickButton(page: .thirdGenerator, buttonName: "reselectpic"))
            showImagePicker()
        case .backButtonTap:
            EventLogManager.shared.logEvent(.clickButton(page: .thirdGenerator, buttonName: "back"))
            router.dismiss()
        case .xmarkTap:
            EventLogManager.shared.logEvent(.clickButton(page: .thirdGenerator, buttonName: "exit"))
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
            EventLogManager.shared.logEvent(.clickButton(page: .thirdGenerator, buttonName: "createpic"))
            EventLogManager.shared.addUserPropertyCount(to: .createNewPhoto)
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
    
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.state.referenceImages = assets
    }
    
    var isActive: Bool {
        return !state.referenceImages.isEmpty
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(faces: state.referenceImages)
    }
    
    func showImagePicker() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.state.showAlert = .albumAuthorization
        case .authorized:
            self.router.routeTo(.imagePicker(limitCount: 3, viewModel: self))
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    self.router.routeTo(.imagePicker(limitCount: 3, viewModel: self))
                } else {
                    self.state.showAlert = .albumAuthorization
                }
            }
        default:
            self.state.showAlert = .reportGentiError(error: GentiError.unknownedError(code: "죄송합니다", message: "앱을 종료후 다시 실행시켜주세요"), action: nil)
            break
        }
    }
}
