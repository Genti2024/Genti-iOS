//
//  PHAssetImageUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit

protocol PHAssetImageUseCase {
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo) async -> UIImage?
    func cancelLoad()
}
