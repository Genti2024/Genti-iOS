//
//  AlbumRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import Foundation
import Photos

protocol AlbumRepository {
    func getAlbums() -> [Album]
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>) -> [PHAsset]
}
