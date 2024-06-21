//
//  AlbumUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation

final class AlbumUseCaseImpl: AlbumUseCase {
    let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    }
    
    func getImageAsset(currentIndex: Int) -> [ImageAsset]? {
        guard let indexSet = getNextIndexSet(currentIndex: currentIndex) else { return nil }
        return albumRepository.getImageAsset(from: indexSet)
    }
    
    private func getNextIndexSet(currentIndex: Int) -> IndexSet? {
        let endIndex = min(currentIndex + 50, albumRepository.numberOfImage)
        guard currentIndex < endIndex else { return nil }
        return IndexSet(currentIndex..<endIndex)
    }
}
