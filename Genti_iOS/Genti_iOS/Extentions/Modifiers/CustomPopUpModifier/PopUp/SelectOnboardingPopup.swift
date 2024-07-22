//
//  SelectOnboardingPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

struct SelectOnboardingPopup: CustomPopup {

    var contentView: some View {
        Image(.selectOnboarding)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 16)
    }

    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTapOutside(true)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}
