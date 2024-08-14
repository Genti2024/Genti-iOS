//
//  PhotoDetailViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import SwiftUI
import UIKit

@Observable
final class PhotoDetailViewModel: ViewModel {
    
    let photoDetailUseCase: PhotoDetailUseCase
    
    var router: Router<MainRoute>
    
    struct State {
        var image: UIImage
        var showToast: ToastType? = nil
    }
    enum Input {
        case downloadButtonTap(from: DetailViewType)
        case xmarkTap
        case backgroundTap
        case shareButtonTap
    }
    
    var state: State
    
    init(photoDetailUseCase: PhotoDetailUseCase, router: Router<MainRoute>, image: UIImage) {
        self.photoDetailUseCase = photoDetailUseCase
        self.router = router
        self.state = .init(image: image)
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .downloadButtonTap(let type):
            Task { await download(type: type) }
        case .xmarkTap, .backgroundTap:
            router.dismissSheet()
        case .shareButtonTap:
            EventLogManager.shared.logEvent(.clickButton(pageName: "mypage", buttonName: "picshare"))
            EventLogManager.shared.addUserPropertyCount(to: .shareButtonTap)
        }
    }
    
    @MainActor
    func download(type: DetailViewType) async {
        do {
            if await photoDetailUseCase.downloadImage(to: state.image) {
                EventLogManager.shared.logEvent(.clickButton(pageName: type.pageName, buttonName: "picdownload"))
                state.showToast = .success
            } else {
                state.showToast = .failure
            }
        }
    }
}
