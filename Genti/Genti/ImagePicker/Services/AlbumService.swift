//
//  AlbumService.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import PhotosUI

final class AlbumService {
    let result: PHFetchResult<PHAsset>
    
    init() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.result = PHAsset.fetchAssets(with: .image, options: options)
    }
    
    var count: Int {
        return result.count
    }
    
    func fetchAssets(from indexSet: IndexSet) -> [PHAsset] {
        var assets = [PHAsset]()
        result.enumerateObjects(at: indexSet) { asset, _, _ in
            assets.append(asset)
        }
        return assets
    }
}
