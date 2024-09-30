//
//  ImageGenerateState.swift
//  Genti_iOS
//
//  Created by uiskim on 9/29/24.
//

enum ImageGenerateState {
    case Inspection(time: String?)
    case needCertification
    case canMake
    case waitComplete
    case canceledBeforeRequest(requestID: Int)
    case waitForWatchingCompletedImage(imageInfo: CompletedPhotoEntity)
}
