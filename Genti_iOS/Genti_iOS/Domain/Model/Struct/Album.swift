//
//  Album.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import Foundation
import Photos

struct Album {
    let name: String
    let album: PHFetchResult<PHAsset>
    
    var count: Int {
      album.count
    }
}

extension Album: Equatable {
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.name == rhs.name
    }
}
