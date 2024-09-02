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
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            let albums = photoUseCase.getAlbums()
            self.state.albums = albums
            if !albums.isEmpty {
                setAlbum(album: self.state.albums[0])
            }
        case .selectAlbum(let album):
            self.state.selectedAlbum = album
            setAlbum(album: album)
            self.state.showAlbumList.toggle()
        case .selectImage(let image):
            if self.state.selectedImages.contains(image) {
                guard let index = self.state.selectedImages.firstIndex(of: image) else { return }
                self.state.selectedImages.remove(at: index)
            } else {
                if state.selectedImages.count == limit {
                    return
                }
                self.state.selectedImages.append(image)
            }
        case .addImageButtonTap:
            generatorViewModel.setReferenceImageAssets(assets: state.selectedImages.map{ ImageAsset(asset: $0) })
            if limit == 3 { EventLogManager.shared.logEvent(.addThreeUserPickture) }
            router.dismissSheet()
        case .xmarkTap:
            router.dismissSheet()
        }
    }
    
    func setAlbum(album: Album) {
        state.selectedAlbum = album
        state.fetchedImages = self.photoUseCase.getPhotos(at: album)
    }

    var router: Router<MainRoute>
    var state: ImagePickerViewModel.State
    let limit: Int
    var generatorViewModel: GetImageFromImagePicker
    var photoUseCase: PhotoUseCaseImpl = PhotoUseCaseImpl(albumRepository: AlbumRepositoryImpl())

    init(router: Router<MainRoute>, limit: Int, generatorViewModel: GetImageFromImagePicker, photoUseCase: PhotoUseCaseImpl) {
        self.router = router
        self.limit = limit
        self.generatorViewModel = generatorViewModel
        self.photoUseCase = photoUseCase
        self.state = .init()
    }
    
    var reachImageLimit: Bool {
        return self.state.selectedImages.count == self.limit
    }
}
