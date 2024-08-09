//
//  UserRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

protocol UserRepository {
    func fetchPhotos() async throws -> [MyImagesEntitiy]
    func checkUserInProgress() async throws -> Bool
    func reportPhoto(responseId: Int, content: String) async throws
    func scorePhoto(responseId: Int, rate: Int) async throws
    func getUserState() async throws -> UserState
    func checkCompletedImage(responeId: Int) async throws
    func checkCanceledImage(requestId: Int) async throws
}
