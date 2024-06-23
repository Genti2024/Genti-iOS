//
//  AlbumUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 6/21/24.
//

import Foundation

protocol AlbumUseCase {
    func getImageAsset(from currentIndex: Int) -> [ImageAsset]?
}
