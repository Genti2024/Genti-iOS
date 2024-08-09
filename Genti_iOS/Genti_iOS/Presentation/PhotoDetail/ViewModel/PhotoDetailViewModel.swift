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
        case downloadButtonTap
        case xmarkTap
        case backgroundTap
    }
    
    var state: State
    
    init(photoDetailUseCase: PhotoDetailUseCase, router: Router<MainRoute>, image: UIImage) {
        self.photoDetailUseCase = photoDetailUseCase
        self.router = router
        self.state = .init(image: image)
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .downloadButtonTap:
            Task { await download() }
        case .xmarkTap, .backgroundTap:
            router.dismissSheet()
        }
    }
    
    @MainActor
    func download() async {
        do {
            if await photoDetailUseCase.downloadImage(to: state.image) {
                state.showToast = .success
            } else {
                state.showToast = .failure
            }
            
        }
    }
}
