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
        var currentIndex = 0
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
        guard let newImages = albumUseCase.getImageAsset(currentIndex: state.currentIndex) else { return }
        state.fetchedImages.append(contentsOf: newImages)
        state.currentIndex += newImages.count
    }
    
    private func updateImageSelection(for imageAsset: ImageAsset) {
        if let index = isSelected(from: imageAsset) {
            removeImage(at: index)
        } else {
            addImage(imageAsset)
        }
    }

    private func removeImage(at index: Int) {
        state.selectedImages.remove(at: index)
        for index in state.selectedImages.indices {
            state.selectedImages[index].assetIndex = index
        }
    }

    private func addImage(_ imageAsset: ImageAsset) {
        guard !state.isReachLimit else { return }
        var newAsset = imageAsset
        newAsset.assetIndex = state.selectedImages.count
        state.selectedImages.append(newAsset)
    }
}
