//
//  AlbumRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation

protocol AlbumRepository {
    var numberOfImage: Int { get }
    func getImageAsset(from indexSet: IndexSet) -> [ImageAsset]
}
