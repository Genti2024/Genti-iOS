//
//  RatingPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

struct RatingPopup: CustomPopup {
    
    let photoInfo: CompletedPhotoEntity
    
    init(photoInfo: CompletedPhotoEntity) {
        self.photoInfo = photoInfo
    }

    var contentView: some View {
        RatingAlertView(viewModel: RatingAlertViewModel(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()), photoInfo: photoInfo))
    }

    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}
