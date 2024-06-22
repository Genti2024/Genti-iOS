//
//  PHAssetImageUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit

final class PHAssetImageUseCaseImpl: PHAssetImageUseCase {

    let service: PHAssetImageService
    
    init(service: PHAssetImageService) {
        self.service = service
    }
    
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo) async -> UIImage? {
        return await service.getImage(from: photoInfo)
    }
    
    func cancelLoad() {
        service.cancelLoad()
    }
}
