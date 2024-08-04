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
        case .randomButtonTap, .viewWillAppear:
            state.currentIndex = (state.currentIndex + 1) % randomDescription.count
            state.currentRandomDescriptionExample = randomDescription[state.currentIndex]
        case .inputDescription(let text):
            state.photoDescription = text
        case .addImageButtonTap:
            switch PHPhotoLibrary.authorizationStatus() {
            case .denied:
                print("거부")
                self.state.showAlert = .albumAuthorization
            case .authorized:
                print("허용")
                self.router.routeTo(.imagePicker(limitCount: 1, viewModel: self))
            case .notDetermined, .restricted:
                print("아직 결정하지 않은 상태")
                PHPhotoLibrary.requestAuthorization { state in
                    if state == .authorized {
                        self.router.routeTo(.imagePicker(limitCount: 1, viewModel: self))
                    } else {
                        self.state.showAlert = .albumAuthorization
                    }
                }
            default:
                break
            }
            
        case .nextButtonTap:
            self.router.routeTo(.secondGen(data: self.requestData()))
        case .xmarkTap:
            self.router.dismissSheet()
        case .removeButtonTap:
            self.removeReferenceImage()
        }
    }
    
    private let randomDescription: [String] = [
        "프랑스 야경을 즐기는 모습을 그려주세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.1",
        "프랑스 야경을 즐기는 모습을 그려주세모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요.2",
        "프랑스 야경을 즐기는 모습을 그려. 항공점퍼를 입고주세요. 항공점퍼를 입고. 항공점퍼를 입고 테라스에 서 있는 모습이에요.3",
        "프랑스 야경을 즐기는 모습을 그려주모습을 그려주세요. 항공점퍼를 입고 테라스세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.4",
    ]
    
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
}
