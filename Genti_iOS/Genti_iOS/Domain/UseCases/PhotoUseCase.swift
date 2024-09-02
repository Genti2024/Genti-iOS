//
//  PhotoUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import Foundation

import Photos

protocol PhotoUseCase {
    func getAlbums() -> [Album]
    func getPhotos(at album: Album) -> [PHAsset]
}

final class PhotoUseCaseImpl: PhotoUseCase  {
    
    private let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    }
    
    func getAlbums() -> [Album] {
        return self.albumRepository.getAlbums()
    }
    
    func getPhotos(at album: Album) -> [PHAsset] {
        return albumRepository.convertAlbumToPHAssets(album: album.album)
    }
}
