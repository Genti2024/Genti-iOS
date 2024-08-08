//
//  AlbumService.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import PhotosUI

protocol AlbumService {
    var album: PHFetchResult<PHAsset> { get }
}

final class AlbumServiceImpl: AlbumService {
    var album: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    private var options: PHFetchOptions = {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }()
    
    init() {
        album = PHAsset.fetchAssets(with: .image, options: options)
    }
}
