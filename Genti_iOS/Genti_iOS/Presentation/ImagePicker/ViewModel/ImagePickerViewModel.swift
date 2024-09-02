//
//  ImagePickerViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import SwiftUI
import Combine
import PhotosUI

@Observable
final class ImagePickerViewModel: ViewModel {
    
    struct State {
        var albums: [Album] = []
        var selectedAlbum: Album? = nil
        var showAlbumList: Bool = false
        var fetchedImages: [PHAsset] = []
        var selectedImages: [PHAsset] = []
    }
    
    enum Input {
        case viewWillAppear
        case selectAlbum(Album)
        case selectImage(PHAsset)
        case addImageButtonTap
        case xmarkTap
    }
    
    private let photoUseCase: PhotoUseCaseImpl
    let limit: Int
    private let generatorViewModel: GetImageFromImagePicker
    
    var router: Router<MainRoute>
    var state: State
    
    init(router: Router<MainRoute>, limit: Int, generatorViewModel: GetImageFromImagePicker, photoUseCase: PhotoUseCaseImpl) {
        self.router = router
        self.limit = limit
        self.generatorViewModel = generatorViewModel
        self.photoUseCase = photoUseCase
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            handleViewWillAppear()
        case .selectAlbum(let album):
            handleSelectAlbum(album)
        case .selectImage(let image):
            handleSelectImage(image)
        case .addImageButtonTap:
            handleAddImageButtonTap()
        case .xmarkTap:
            router.dismissSheet()
        }
    }
    
    private func handleViewWillAppear() {
        state.albums = photoUseCase.getAlbums()
        if let firstAlbum = state.albums.first {
            setAlbum(album: firstAlbum)
        }
    }
    
    private func handleSelectAlbum(_ album: Album) {
        state.selectedAlbum = album
        setAlbum(album: album)
        state.showAlbumList.toggle()
    }
    
    private func handleSelectImage(_ image: PHAsset) {
        if let index = state.selectedImages.firstIndex(of: image) {
            state.selectedImages.remove(at: index)
        } else if state.selectedImages.count < limit {
            state.selectedImages.append(image)
        }
    }
    
    private func handleAddImageButtonTap() {
        let imageAssets = state.selectedImages.map { ImageAsset(asset: $0) }
        generatorViewModel.setReferenceImageAssets(assets: imageAssets)
        logEvent()
        router.dismissSheet()
    }
    
    private func setAlbum(album: Album) {
        state.selectedAlbum = album
        state.fetchedImages = photoUseCase.getPhotos(at: album)
    }
    
    private func logEvent() {
        if limit == 3 {
            EventLogManager.shared.logEvent(.addThreeUserPickture)
        }
    }
    
    var reachImageLimit: Bool {
        return state.selectedImages.count == limit
    }
}
