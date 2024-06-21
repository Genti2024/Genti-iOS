//
//  AlbumServiceImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation
import Photos

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
