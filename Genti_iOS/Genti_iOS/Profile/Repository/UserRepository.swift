//
//  UserRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

protocol UserRepository {
    func getMyPictures(page: Int) async throws -> MyImagesEntitiy
    func checkInProgress() async throws -> Bool
    func reportPhoto(id: Int, content: String) async throws
}
