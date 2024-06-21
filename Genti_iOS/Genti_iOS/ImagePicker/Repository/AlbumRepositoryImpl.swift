//
//  AlbumRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation

final class AlbumRepositoryImpl: AlbumRepository {

    let albumService: AlbumService
    
    init(albumService: AlbumService) {
        self.albumService = albumService
    }
    
    var numberOfImage: Int {
        return albumService.album.count
    }
    
    func getImageAsset(from indexSet: IndexSet) -> [ImageAsset] {
        return indexSet
            .compactMap{ albumService.album.object(at: $0) }
            .map{ ImageAsset(asset: $0) }
    }
}
