//
//  PHAssetImageRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import UIKit

final class PHAssetImageRepositoryImpl: PHAssetImageRepository {

    let service: PHAssetImageService
    
    init(service: PHAssetImageService) {
        self.service = service
    }
    
    func getImage(from photoInfo: PHAssetImageViewModel.PhotoInfo, completionHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        service.getImage(from: photoInfo, completionHandler: completionHandler)
    }
    
    func cancelLoad() {
        service.cancelLoad()
    }
}
