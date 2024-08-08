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
        var selectedImages: [ImageAsset] = []
        var isReachLimit: Bool = false
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
            update(for: imageAsset)
            state.isReachLimit = state.selectedImages.count == limit
        case .readContentHight(let height):
            if state.contentSize != height { state.contentSize = height }
        case .scroll(let originY):
            if isReachBottom(from: originY) { fetch() }
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

    private let albumRepository: AlbumRepository
    var scrollViewHeight: CGFloat = 0

    init(generatorViewModel: GetImageFromImagePicker, router: Router<MainRoute>, limit: Int, albumRepository: AlbumRepository) {
        self.generatorViewModel = generatorViewModel
        self.router = router
        self.limit = limit
        self.albumRepository = albumRepository
        self.state = .init()
    }
    
    /// 이미 선택된 이미지들중 인자로 들어온 이미지가 몇번째 이미지인지를 반환합니다
    /// - Parameter imageAsset: 인덱스를 알고싶은 이미지
    /// - Returns: 인덱스를반환합니다(없다면 nil을 반환합니다)
    func index(of imageAsset: ImageAsset) -> Int? {
        state.selectedImages.firstIndex { $0.id == imageAsset.id }
    }
    
    /// 이미 선택된 이미지들중 인자로 들어온 이미지의 포함여부를 반환합니다
    /// - Parameter imageAsset: 선택된이미지들중에 포함되어있는지를 알고싶은 이미지
    /// - Returns: 포함여부를 반환합니다
    func containsInSelectedImages(_ imageAsset: ImageAsset) -> Bool {
        if let _ = state.selectedImages.firstIndex(where: { $0.id == imageAsset.id }) {
            return true
        }
        return false
    }
    
    /// pagination으로 인한 추가 이미지를 가져옵니다
    /// 이미지를 가지고 오는 동안에는 이미지를 가져오는 동작을 block합니다(순식간에 여러번호출되는경우를 예방)
    private func fetch() {
        defer { state.isLoading = false }
        guard !state.isLoading else { return }
        state.isLoading = true
        appendImages()
    }
    
    /// 이미지를 추가합니다
    /// 현재 이미지 pagination을 구현해놨기때문에 이미지가 계속해서 추가되어야합니다 UseCase에서 이미지를 받아와서 fetch된이미지에추가하고 인덱스값을 갱신해줍니다
    private func appendImages() {
        guard let newImages = self.getImageAsset(from: state.currentIndex) else { return }
        state.fetchedImages.append(contentsOf: newImages)
        state.currentIndex += newImages.count
    }
    
    /// 앨범에서 Pagination을 구현하기위한 indexset을 구합니다
    /// - Parameter currentIndex: 현재 이미지의 인덱스
    /// - Returns:
    func getImageAsset(from currentIndex: Int) -> [ImageAsset]? {
        guard let indexSet = getNextIndexSet(currentIndex: currentIndex, quantity: 50) else { return nil }
        return albumRepository.getImageAsset(from: indexSet)
    }
    
    /// pagination으로 인해 추가로 가져올 이미지들의 IndexSet을 구합니다
    /// - Parameters:
    ///   - currentIndex: 현재까지 가져온 이미지의 갯수
    ///   - quantity: 한번에 가져올 이미지의 갯수
    /// - Returns: 추가적으로 가져올 이미지의 IndexSet
    private func getNextIndexSet(currentIndex: Int, quantity: Int) -> IndexSet? {
        let endIndex = min(currentIndex + quantity, albumRepository.numberOfImage)
        guard currentIndex < endIndex else { return nil }
        return IndexSet(currentIndex..<endIndex)
    }
    
    /// 앨범이미지를 선택합니다
    /// - Parameter imageAsset: 선택한 이미지에셋
    /// 만약에 선택한 이미지가 이미 선택된이미지에 있는이미지라면 -> 선택해제(removeImage(at:_)))
    /// 만약에 선택한 이미지가 선택되지 않은 이미지라면 -> 선택(addImage())
    private func update(for imageAsset: ImageAsset) {
        if let index = index(of: imageAsset) {
            deSelect(at: index)
        } else {
            add(imageAsset)
        }
    }

    /// 선택된 이미지를 선택해제합니다
    /// - Parameter index: 이미선택된이미지들중에서 몇번째이미지지인지
    /// 선택된이미지에는 몇번째 선택한이미지인지를 UI로 보여줘야하기때문에 123에서 2번째 이미지를 선택해제하면 3이 2가되야합니다
    private func deSelect(at index: Int) {
        state.selectedImages.remove(at: index)
        for index in state.selectedImages.indices {
            state.selectedImages[index].assetIndex = index
        }
    }

    /// 이미지를 선택합니다
    /// - Parameter imageAsset: 선택된 이미지
    private func add(_ imageAsset: ImageAsset) {
        guard !state.isReachLimit else { return }
        var newAsset = imageAsset
        newAsset.assetIndex = state.selectedImages.count
        state.selectedImages.append(newAsset)
    }
    
    /// scrollview가 맨 아래에 도달했는지를 판단합니다
    /// - Parameter originY: 현재 scrollview의 originY좌표
    /// - Returns: 바닥에 도달했는지안했는지
    private func isReachBottom(from originY: CGFloat) -> Bool {
        return scrollViewHeight > state.contentSize + originY
    }
}
