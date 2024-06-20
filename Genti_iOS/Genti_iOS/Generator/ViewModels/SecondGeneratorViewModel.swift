//
//  SecondGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI

@Observable final class SecondGeneratorViewModel {
    
    var requestImageData: RequestImageData
    
    init(requestImageData: RequestImageData) {
        self.requestImageData = requestImageData
    }
    
    var selectedAngle: PhotoAngle? = nil
    var selectedFrame: PhotoFrame? = nil
    var selectedRatio: PhotoRatio? = nil
    
    var angleOrFrameOrRatioIsEmpty: Bool {
        return selectedAngle == nil || selectedFrame == nil || selectedRatio == nil
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(angle: self.selectedAngle,
                               frame: self.selectedFrame,
                               ratio: self.selectedRatio)
    }
}
