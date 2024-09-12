//
//  ImageRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import UIKit

protocol ImageRepository {
    func writeToPhotoAlbum(image: UIImage?) async -> Bool
}
