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
    
    var reachImageLimit: Bool {
        return state.selectedImages.count == limit
    }
    
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
    
    
    /// view가 appear되면 실행되는 메서드
    /// album목록을 가져오고 앨범이 1개라도 있으면 유저가 기본으로 보는 앨범을 해당 앨범으로 설정해둔다
    private func handleViewWillAppear() {
        state.albums = photoUseCase.getAlbums()
        if let firstAlbum = state.albums.first {
            setAlbum(album: firstAlbum)
        }
    }
    
    /// 앨범list에서 하나의 앨범을 선택하면 실행되는 메서드
    /// - Parameter album: 유저가 선택한 앨범
    /// 선택한 앨범을 해당 앨범으로 설정해고
    /// setAlbum(albume:_)을 실행해 해당앨범을 선택했을때 앨범에 있는 이미지들을 유저가 볼수있게 처리한다
    /// 유저가 앨범을 선택했다면 앨범리스트를 보여줄필요가없으니 flag를 toggle로(false) 처리한다
    private func handleSelectAlbum(_ album: Album) {
        state.selectedAlbum = album
        setAlbum(album: album)
        state.showAlbumList.toggle()
    }
    
    /// 유저가 앨범의 이미지를 선택하면 실행되는 메서드
    /// - Parameter image: 유저가 선택한 이미지의 meta data(PHAsset)
    /// 이미 선택된 이미지를 다시선택했다면 -> 선택해제
    /// 만약에 선택가능한 최대갯수(limit)에 도달하지 않았을때만 선택된 이미지에 유저가 선택한 이미지 추가
    private func handleSelectImage(_ image: PHAsset) {
        if let index = state.selectedImages.firstIndex(of: image) {
            state.selectedImages.remove(at: index)
        } else if state.selectedImages.count < limit {
            state.selectedImages.append(image)
        }
    }
    
    // MARK: - 확인
    /// 유저가 이미지 선택을 완료하면 실행되는 메서드
    /// 데이터를 전달하는 방식을 reactorkit의 global state등으로 변경할 필요성을 느낌(추후작업)
    /// PHAsset을 굳이 uuid가 있는 ImagAsset으로 바꿀필요가있을까...?
    /// forEach때문에 설정하긴했는데 identifiable이 아니더라도 \.self로 해도 큰문제는 없을거같음
    private func handleAddImageButtonTap() {
        let imageAssets = state.selectedImages.map { ImageAsset(asset: $0) }
        generatorViewModel.setReferenceImageAssets(assets: imageAssets)
        logEvent()
        router.dismissSheet()
    }
    
    
    /// 앨범 list에서 하나의 앨범을 선택하면 실행되는 메서드
    /// - Parameter album: 유저가 선택한 앨범
    /// 선택된 앨범에 해당앨범을 저장
    /// 해당 앨범의 phasset을 usecase로부터 받아와서 fetchedImage(앨범의이미지)에 넣어줌
    private func setAlbum(album: Album) {
        state.selectedAlbum = album
        state.fetchedImages = photoUseCase.getPhotos(at: album)
    }
    
    /// 만약에 유저가 이미지를 3장선택하고 완료버튼을 눌렀는지에대한 데이터가 기획측에서 필요하다해서 넣은 log
    private func logEvent() {
        if limit == 3 {
            EventLogManager.shared.logEvent(.addThreeUserPickture)
        }
    }
}
