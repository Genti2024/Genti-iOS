//
//  ProfileUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

protocol ProfileUseCase {
    func getCompletedPhotos(page: Int) async throws -> MyImagesEntitiy
}
