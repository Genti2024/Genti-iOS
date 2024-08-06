//
//  FirstGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI
import Combine
import Photos

@Observable 
final class FirstGeneratorViewModel: ViewModel, GetImageFromImagePicker {
    
    var router: Router<MainRoute>
    var state: FirstGeneratorViewModel.State
    
    struct State {
        var currentIndex: Int = -1
        var currentRandomDescriptionExample: String = ""
        var photoDescription: String = ""
        var referenceImages: [ImageAsset] = []
        var showAlert: AlertType? = nil
    }
    
    enum Input {
        case viewWillAppear
        case randomButtonTap
        case inputDescription(String)
        case addImageButtonTap
        case nextButtonTap
        case xmarkTap
        case removeButtonTap
    }
    
    
    init(router: Router<MainRoute>) {
        self.router = router
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            randomDescription = randomDescription.shuffled()
            state.currentIndex = (state.currentIndex + 1) % randomDescription.count
            state.currentRandomDescriptionExample = randomDescription[state.currentIndex]
        case .randomButtonTap:
            state.currentIndex = (state.currentIndex + 1) % randomDescription.count
            state.currentRandomDescriptionExample = randomDescription[state.currentIndex]
        case .inputDescription(let text):
            state.photoDescription = text
        case .addImageButtonTap:
            showImagePicker()
        case .nextButtonTap:
            self.router.routeTo(.secondGen(data: self.requestData()))
        case .xmarkTap:
            self.router.dismissSheet()
        case .removeButtonTap:
            self.removeReferenceImage()
        }
    }
    
    private var randomDescription: [String] = Constants.examplePrompts
    
    func setReferenceImageAssets(assets: [ImageAsset]) {
        self.state.referenceImages = assets
    }
    
    func removeReferenceImage() {
        self.state.referenceImages = []
    }

    var descriptionIsEmpty: Bool {
        return state.photoDescription.isEmpty
    }
    
    func requestData() -> RequestImageData {
        var requestImageData = RequestImageData()
        if state.referenceImages.isEmpty {
            return requestImageData.set(description: self.state.photoDescription, reference: nil)
        } else {
            return requestImageData.set(description: self.state.photoDescription, reference: state.referenceImages[0])
        }
    }
    
    func showImagePicker() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.state.showAlert = .albumAuthorization
        case .authorized:
            self.router.routeTo(.imagePicker(limitCount: 1, viewModel: self))
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    self.router.routeTo(.imagePicker(limitCount: 1, viewModel: self))
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
