//
//  ProfileUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation
import UIKit

protocol ProfileUseCase {
    func fetchInitalUserInfo() async throws -> UserInfoEntity
    func getCompletedPhotos(page: Int) async throws -> MyImagesEntitiy
    func load(from urlString: String) async -> UIImage?
}

struct UserInfoEntity {
    var hasInProgressPhoto: Bool
    var completedImage: MyImagesEntitiy
}
