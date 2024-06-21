//
//  ImagePickerViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Combine
import PhotosUI

@Observable 
final class ImagePickerViewModel: ViewModel {

    struct State {
        var fetchedImages: [ImageAsset] = []
        var isReachLimit: Bool = false
        var selectedImages: [ImageAsset] = []
        var isLoading: Bool = false
        var currentIndex: Int = 0
        var contentSize: CGFloat = 0
    }
    
    enum Input {
        case scroll(CGFloat)
        case selectImage(ImageAsset)
        case readContentHight(CGFloat)
        case xmarkTap
        case addImageButtonTap
        case viewDidAppear
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .selectImage(let imageAsset):
            updateImageSelection(for: imageAsset)
            state.isReachLimit = state.selectedImages.count == limit
        case .readContentHight(let height):
            if state.contentSize != height {
                state.contentSize = height
            }
        case .scroll(let orginY):
            if scrollViewHeight > state.contentSize + orginY {
                fetchImages()
            }
        case .xmarkTap:
            router.dismissSheet()
        case .addImageButtonTap:
            generatorViewModel.setReferenceImageAssets(assets: state.selectedImages)
            router.dismissSheet()
        case .viewDidAppear:
            state.selectedImages.removeAll()
        }
    }
    
    var generatorViewModel: GetImageFromImagePicker
    var router: Router<MainRoute>
    var state: ImagePickerViewModel.State
    let limit: Int
    
    private let albumUseCase: AlbumUseCase
    var scrollViewHeight: CGFloat = 0

    
    init(generatorViewModel: GetImageFromImagePicker, router: Router<MainRoute>, limit: Int, albumUseCase: AlbumUseCase) {
        self.generatorViewModel = generatorViewModel
        self.router = router
        self.limit = limit
        self.albumUseCase = albumUseCase
        self.state = .init()
    }
    
    func isSelected(from imageAsset: ImageAsset) -> Int? {
        state.selectedImages.firstIndex { $0.id == imageAsset.id }
    }
    
    private func fetchImages() {
        defer { state.isLoading = false }
        guard !state.isLoading else { return }
        state.isLoading = true
        appendImages()
    }
    
    
    /// 이미지를 추가합니다
    /// 현재 이미지 pagination을 구현해놨기때문에 이미지가 계속해서 추가되어야합니다 UseCase에서 이미지를 받아와서 fetch된이미지에추가하고 인덱스값을 갱신해줍니다
    private func appendImages() {
        guard let newImages = albumUseCase.getImageAsset(from: state.currentIndex) else { return }
        state.fetchedImages.append(contentsOf: newImages)
        state.currentIndex += newImages.count
    }
    
    /// 앨범이미지를 선택합니다
    /// - Parameter imageAsset: 선택한 이미지에셋
    /// 만약에 선택한 이미지가 이미 선택된이미지에 있는이미지라면 -> 선택해제(removeImage(at:_)))
    /// 만약에 선택한 이미지가 선택되지 않은 이미지라면 -> 선택(addImage())
    private func updateImageSelection(for imageAsset: ImageAsset) {
        if let index = isSelected(from: imageAsset) {
            removeImage(at: index)
        } else {
            addImage(imageAsset)
        }
    }

    
    /// 선택된 이미지를 선택해제합니다
    /// - Parameter index: 이미선택된이미지들중에서 몇번째이미지지인지
    /// 선택된이미지에는 몇번째 선택한이미지인지를 UI로 보여줘야하기때문에 123에서 2번째 이미지를 선택해제하면 3이 2가되야합니다
    private func removeImage(at index: Int) {
        state.selectedImages.remove(at: index)
        for index in state.selectedImages.indices {
            state.selectedImages[index].assetIndex = index
        }
    }

    
    /// 이미지를 선택합니다
    /// - Parameter imageAsset: 선택된 이미지
    private func addImage(_ imageAsset: ImageAsset) {
        guard !state.isReachLimit else { return }
        var newAsset = imageAsset
        newAsset.assetIndex = state.selectedImages.count
        state.selectedImages.append(newAsset)
    }
}
