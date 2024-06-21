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
