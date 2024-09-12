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
        var imageUrl: String
        var image: UIImage?
        var showToast: ToastType? = nil
    }
    enum Input {
        case downloadButtonTap(from: DetailViewType)
        case xmarkTap
        case backgroundTap
        case shareButtonTap
        case imageLoad(UIImage)
    }
    
    var state: State
    
    init(photoDetailUseCase: PhotoDetailUseCase, router: Router<MainRoute>, imageUrl: String) {
        self.photoDetailUseCase = photoDetailUseCase
        self.router = router
        self.state = .init(imageUrl: imageUrl)
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .downloadButtonTap(let type):
            Task { await download(type: type) }
        case .xmarkTap, .backgroundTap:
            router.dismissSheet()
        case .shareButtonTap:
            EventLogManager.shared.logEvent(.clickButton(page: .profile, buttonName: "picshare"))
            EventLogManager.shared.addUserPropertyCount(to: .shareButtonTap)
        case .imageLoad(let image):
            self.state.image = image
        }
    }
    
    @MainActor
    func download(type: DetailViewType) async {
        do {
            guard let image = state.image else { return }
            if await photoDetailUseCase.downloadImage(to: image) {
                EventLogManager.shared.logEvent(.clickButton(page: type.initalPage, buttonName: "picdownload"))
                state.showToast = .success
            } else {
                state.showToast = .failure
            }
        }
    }
    
    var getImage: Image {
        if let image = self.state.image {
            return Image(uiImage: image)
        }
        return Image(uiImage: UIImage(resource: .camera))
    }
}
