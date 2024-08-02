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
    
    let imageRepository: ImageRepository
    let hapticRepository: HapticRepository
    
    var router: Router<MainRoute>
    
    struct State {
        var image: UIImage
    }
    enum Input {
        case downloadButtonTap
        case xmarkTap
    }
    
    var state: State
    
    init(imageRepository: ImageRepository, hapticRepository: HapticRepository, router: Router<MainRoute>, image: UIImage) {
        self.imageRepository = imageRepository
        self.hapticRepository = hapticRepository
        self.router = router
        self.state = .init(image: image)
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .downloadButtonTap:
            Task { await download() }
        case .xmarkTap:
            router.dismissSheet()
        }
    }
    
    @MainActor
    func download() async {
        do {
            let writeSuccess = await imageRepository.writeToPhotoAlbum(image: state.image)
            hapticRepository.notification(type: writeSuccess ? .success : .error)
        }
    }
}
