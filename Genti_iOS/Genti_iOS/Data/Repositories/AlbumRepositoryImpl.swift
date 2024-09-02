//
//  AlbumRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 9/2/24.
//

import Foundation

import Photos

final class AlbumRepositoryImpl: AlbumRepository {
  
  // MARK: - Properties
  
  private let sortDescriptors = [
    NSSortDescriptor(key: "creationDate", ascending: false),
    NSSortDescriptor(key: "modificationDate", ascending: false)
  ]
  
  private lazy var fetchOptions = self.makeFetchOptions()
  
  init() {}
  
  func getAlbums() -> [Album] {
    var albums = [Album]()
    
    let smartAlbums = getSmartAlbums()
    albums.append(contentsOf: smartAlbums)
    
    let normalAlbums = getNormalAlbums()
    albums.append(contentsOf: normalAlbums)
    
    return albums
  }
    
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>) -> [PHAsset] {
        var assets = [PHAsset]()
        album.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        return assets
    }
  
  private func getSmartAlbums() -> [Album] {
    let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil )
    return convertAssetCollectionToAlbums(smartAlbums)
  }
  
  private func getNormalAlbums() -> [Album] {
    let normalAlbums = PHAssetCollection.fetchAssetCollections(with: .album,
      subtype: .any,
      options: PHFetchOptions()
    )
    
    let albums = convertAssetCollectionToAlbums(normalAlbums)
    return albums
  }
  
  private func convertAssetCollectionToAlbums(
    _ collection: PHFetchResult<PHAssetCollection>
  ) -> [Album] {
    var albums = [Album]()
    
    collection.enumerateObjects { [weak self] assetCollection, _, _ in
      guard let self else { return }
      
      let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
      if fetchResult.count != 0 {
        let album = Album(name: assetCollection.localizedTitle ?? "Unknown Album", album: fetchResult)
        albums.append(album)
      }
    }
    
    return albums
  }
  
  private func makeFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = self.makePredicate()
    fetchOptions.sortDescriptors = self.sortDescriptors
    return fetchOptions
  }
  
  private func makePredicate() -> NSPredicate {
    let format = "mediaType == %d"
    return .init(format: format, PHAssetMediaType.image.rawValue)
  }
}

