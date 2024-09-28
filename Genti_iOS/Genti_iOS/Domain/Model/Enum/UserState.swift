//
//  UserState.swift
//  Genti_iOS
//
//  Created by uiskim on 9/28/24.
//


enum UserState {
    case inProgress
    case canMake
    case awaitUserVerification(CompletedPhotoEntity)
    case canceled(requestId: Int)
    case error
}