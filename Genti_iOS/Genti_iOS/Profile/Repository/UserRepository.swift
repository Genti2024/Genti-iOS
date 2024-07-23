//
//  UserRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

protocol UserRepository {
    func fetchPhotos(page: Int) async throws -> MyImagesEntitiy
    func checkUserStatus() async throws -> Bool
    func reportPhoto(id: Int, content: String) async throws
    func scorePhoto(rate: Int) async throws
}
