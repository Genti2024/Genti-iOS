//
//  CompletePhotoEntity.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import Foundation

struct CompletePhotoEntity {
    var requestId: Int
    var responseId: Int
    var imageUrlString: String
    var imageRatio: PhotoRatio
    
    init(requestId: Int, photoInfo: UserStateDTO.PictureGenerateResponse) {
        self.requestId = requestId
        self.responseId = photoInfo.pictureGenerateResponseId
        self.imageUrlString = photoInfo.pictureCompleted.url
        self.imageRatio = photoInfo.pictureCompleted.pictureRatio == "RATIO_3_2" ? .threeSecond : .twoThird
    }
    
    init() {
        self.requestId = 1
        self.responseId = 2
        self.imageUrlString = "https://d2rvmd5lmgmzuf.cloudfront.net/ADMIN_UPLOADED_IMAGE/어드민응답1.png-f8614bc9-3614-40bb-a91e-f8398be66d7c"
        self.imageRatio = .twoThird
    }
}
