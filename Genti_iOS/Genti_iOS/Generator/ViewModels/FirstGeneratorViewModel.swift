//
//  FirstGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI

@Observable final class FirstGeneratorViewModel: GetImageFromImagePicker {
    // firstView
    private var currentIndex: Int = -1
    private let randomDescription: [String] = [
        "프랑스 야경을 즐기는 모습을 그려주세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.1",
        "프랑스 야경을 즐기는 모습을 그려주세모습을 그려주세요. 항공점퍼를 입고 테라스모습을 그려주세요.2",
        "프랑스 야경을 즐기는 모습을 그려. 항공점퍼를 입고주세요. 항공점퍼를 입고. 항공점퍼를 입고 테라스에 서 있는 모습이에요.3",
        "프랑스 야경을 즐기는 모습을 그려주모습을 그려주세요. 항공점퍼를 입고 테라스세요. 항공점퍼를 입고 테라스에 서 있는 모습이에요.4",
    ]
    
    var referenceImages: [ImageAsset] = []
    
    func removeReferenceImage() {
        self.referenceImages = []
    }

    var photoDescription: String = ""
    var currentRandomDescriptionExample: String = ""
    
    func getRandomDescriptionExample() {
        currentIndex = (currentIndex + 1) % randomDescription.count
        self.currentRandomDescriptionExample = randomDescription[currentIndex]
    }
    
    var descriptionIsEmpty: Bool {
        return photoDescription.isEmpty
    }
    
    func requestData() -> RequestImageData {
        var requestImageData = RequestImageData()
        if referenceImages.isEmpty {
            return requestImageData.set(description: self.photoDescription, reference: nil)
        } else {
            return requestImageData.set(description: self.photoDescription, reference: referenceImages[0])
            
        }
    }
}
