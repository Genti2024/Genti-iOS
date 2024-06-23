//
//  ImageDataTransferService.swift
//  Genti_iOS
//
//  Created by uiskim on 6/23/24.
//

import Foundation
import Photos

protocol ImageDataTransferService {
    func requestImageData(for asset: PHAsset) async throws -> Data
}
