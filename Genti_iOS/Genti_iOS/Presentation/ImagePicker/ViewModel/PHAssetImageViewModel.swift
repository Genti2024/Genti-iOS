//
//  PHAssetImageViewModel.swift
//  Genti
//
//  Created by uiskim on 5/4/24.
//

import UIKit
import Combine
import Photos

@Observable 
final class PHAssetImageViewModel: ViewModel {
    
    struct State {
        var image: UIImage? = nil
    }
    
    enum Input {
        case viewWillAppear(PHAssetImageViewModel.PhotoInfo)
        case viewDidAppear
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear(let photoInfo):
            load(from: photoInfo)
        case .viewDidAppear:
            cancel()
        }
    }
    
    struct PhotoInfo {
        let size: CGSize
        let asset: PHAsset
    }
    
    var state: PHAssetImageViewModel.State
    var phassetImageRepository: PHAssetImageRepository
    
    init(phassetImageRepository: PHAssetImageRepository) {
        self.phassetImageRepository = phassetImageRepository
        self.state = .init()
    }

    /// PHAsset으로부터 UIImage를 반환받아 state의 image에 할당해줍니다
    /// - Parameter photoInfo: PHAsset과 Size가 담겨있는 custom Struct 
    func load(from photoInfo: PHAssetImageViewModel.PhotoInfo) {
        phassetImageRepository.getImage(from: photoInfo) { image, _ in
            DispatchQueue.main.async {
                self.state.image = image
            }
        }
    }
    
    /// PHAsset에서 UIImage로의 변환을 취소합니다
    func cancel() {
        phassetImageRepository.cancelLoad()
    }
}
