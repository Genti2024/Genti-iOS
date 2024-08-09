//
//  AlbumUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation

protocol AlbumUseCase {
    func getImageAsset(from currentIndex: Int) -> [ImageAsset]?
}

final class AlbumUseCaseImpl: AlbumUseCase {
    let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    }
    
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
}
