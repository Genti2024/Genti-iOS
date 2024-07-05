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
        var image: UIImage? = nil
    }
    enum Input {
        case viewWillAppear
        case downloadButtonTap
        case xmarkTap
    }

    var state: State
    var imageUrlString: String
    
    init(imageRepository: ImageRepository, hapticRepository: HapticRepository, router: Router<MainRoute>, imageUrlString: String) {
        self.imageRepository = imageRepository
        self.hapticRepository = hapticRepository
        self.router = router
        self.imageUrlString = imageUrlString
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            Task {
                do {
                    state.image = await imageRepository.load(from: imageUrlString)
                }
            }
        case .downloadButtonTap:
            Task {
                do {
                    let writeSuccess = await imageRepository.writeToPhotoAlbum(image: state.image)
                    hapticRepository.notification(type: writeSuccess ? .success : .error)
                }
            }
        case .xmarkTap:
            router.dismissSheet()
        }
    }
    
    var getImage: Image {
        if let image = self.state.image {
            return Image(uiImage: image)
        }
        return Image(uiImage: UIImage())
    }
    
    var getUIImage: UIImage {
        if let image = self.state.image {
            return image
        }
        return UIImage()
    }
    
    var disabled: Bool {
        if let _ = self.state.image {
            return true
        }
        return false
    }
}
