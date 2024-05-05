//
//  ImagePickerViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Combine
import PhotosUI

final class ImagePickerViewModel: ObservableObject {

    @Published var scrollViewHeight: CGFloat = 0
    @Published var contentSize: CGFloat = 0
    @Published var fetchedImages: [ImageAsset] = []
    @Published var isReachLimit: Bool = false
    @Published var selectedImages: [ImageAsset] = [] {
        didSet {
            isReachLimit = selectedImages.count == limit
        }
    }
    
    private let fetchTrigger = PassthroughSubject<Void, Never>()
    private var currentIndex = 0
    private let fetchLimit = 50
    private var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let albumService: AlbumService = AlbumServiceImpl()
    let limit: Int
    
    init(limitCount: Int) {
        self.limit = limitCount
        setupBindings()
    }
    
    var selectedImageCount: Int {
        selectedImages.count
    }

    func getPhotos() {
        fetchTrigger.send()
    }
    
    func isSelected(from imageAsset: ImageAsset) -> Int? {
        selectedImages.firstIndex { $0.id == imageAsset.id }
    }
    
    func removeAll() {
        selectedImages.removeAll()
    }
    
    private func setupBindings() {
        fetchTrigger
            .filter { [weak self] in self?.isLoading == false }
            .handleEvents(receiveOutput: { [weak self] in self?.isLoading = true })
            .compactMap { [weak self] in self?.getNextIndexSet() }
            .compactMap { [weak self] in self?.albumService.convertAlbumToImageAsset(indexSet: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.fetchedImages.append(contentsOf: $0)
                self?.currentIndex += $0.count
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    private func getNextIndexSet() -> IndexSet? {
        let endIndex = min(currentIndex + fetchLimit, albumService.count)
        guard reachLastIndex(to: endIndex) else {
            isLoading = false
            return nil
        }
        return IndexSet(currentIndex..<endIndex)
    }
    
    private func reachLastIndex(to endIndex: Int) -> Bool {
        return currentIndex < endIndex
    }
    
    deinit {
        print("ImagePickerViewModel deinit")
    }
}
