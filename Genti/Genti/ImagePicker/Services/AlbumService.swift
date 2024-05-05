//
//  AlbumService.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import PhotosUI
import SwiftUI

protocol AlbumService {
    var count: Int { get }
    func convertAlbumToImageAsset(indexSet: IndexSet) -> [ImageAsset]
}

final class AlbumServiceImpl: AlbumService {
    private var album: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    
    init() {
        fetchAlbum()
    }
    
    var count: Int { album.count }
    
    func convertAlbumToImageAsset(indexSet: IndexSet) -> [ImageAsset] {
        return indexSet
            .compactMap { album.object(at: $0) }
            .map { ImageAsset(asset: $0) }
    }
    
    private func fetchAlbum() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        album = PHAsset.fetchAssets(with: .image, options: options)
    }
}
