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
                fetchTrigger.send()
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
    
    private let fetchTrigger = PassthroughSubject<Void, Never>()
    private let fetchLimit = 50
    private var cancellables = Set<AnyCancellable>()
    private let albumService: AlbumService = AlbumServiceImpl()
    var scrollViewHeight: CGFloat = 0

    
    init(generatorViewModel: GetImageFromImagePicker, router: Router<MainRoute>, limit: Int) {
        self.generatorViewModel = generatorViewModel
        self.router = router
        self.limit = limit
        self.state = .init()
        setupBindings()
    }
    
    func isSelected(from imageAsset: ImageAsset) -> Int? {
        state.selectedImages.firstIndex { $0.id == imageAsset.id }
    }
    
    private func setupBindings() {
        fetchTrigger
            .filter { [weak self] in self?.state.isLoading == false }
            .handleEvents(receiveOutput: { [weak self] in self?.state.isLoading = true })
            .compactMap { [weak self] in self?.getNextIndexSet() }
            .compactMap { [weak self] in self?.albumService.convertAlbumToImageAsset(indexSet: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] assets in
                self?.state.fetchedImages.append(contentsOf: assets)
                self?.state.currentIndex += assets.count
                self?.state.isLoading = false
            })
            .store(in: &cancellables)
    }

    private func getNextIndexSet() -> IndexSet? {
        let endIndex = min(state.currentIndex + fetchLimit, albumService.count)
        guard reachLastIndex(to: endIndex) else {
            state.isLoading = false
            return nil
        }
        return IndexSet(state.currentIndex..<endIndex)
    }
    
    private func reachLastIndex(to endIndex: Int) -> Bool {
        return state.currentIndex < endIndex
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
        updateAssetIndices()
    }

    private func addImage(_ imageAsset: ImageAsset) {
        guard !state.isReachLimit else { return }
        var newAsset = imageAsset
        newAsset.assetIndex = state.selectedImages.count
        state.selectedImages.append(newAsset)
    }

    private func updateAssetIndices() {
        for index in state.selectedImages.indices {
            state.selectedImages[index].assetIndex = index
        }
    }
    
}
