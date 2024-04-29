//
//  ImagePickerViewModel.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import PhotosUI
import Combine

final class ImagePickerViewModel: ObservableObject {
    @Published var fetchedImages: [ImageAsset] = []
    @Published var selectedImages: [ImageAsset] = []
    @Published var isReachLimit: Bool = false
    var limit: Int
    
    private var currentIndex = 0
    private let fetchLimit = 40
    private var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    let albumService: AlbumService
    
    init(albumService: AlbumService, limitCount: Int) {
        self.albumService = albumService
        self.limit = limitCount
        getPhotosWithPagination()
        
        $selectedImages
            .map { $0.count == self.limit }
            .sink { self.isReachLimit = $0 }
            .store(in: &cancellables)
            
        
    }
  
    func fetchImages(indexSet: IndexSet) -> [ImageAsset] {
        return albumService.fetchAssets(from: indexSet)
            .map { ImageAsset(asset: $0) }
    }

    public func getPhotosWithPagination() {
        isLoading = true
        let endIndex = min(currentIndex + fetchLimit, albumService.count)
        let indexSet = IndexSet(currentIndex..<endIndex)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let assets = self.fetchImages(indexSet: indexSet)
            DispatchQueue.main.async {
                self.fetchedImages.append(contentsOf: assets)
                self.currentIndex = endIndex
                self.isLoading = false
            }
        }
    }
}
