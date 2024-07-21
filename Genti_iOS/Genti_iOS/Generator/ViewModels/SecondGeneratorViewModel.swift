//
//  SecondGeneratorViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/20/24.
//

import SwiftUI

@Observable 
final class SecondGeneratorViewModel: ViewModel {
 
    var router: Router<MainRoute>
    var requestImageData: RequestImageData
    var state: State
    var userdefaultRepository: UserDefaultsRepository
    
    init(requestImageData: RequestImageData, router: Router<MainRoute>, userdefaultRepository: UserDefaultsRepository) {
        self.requestImageData = requestImageData
        self.userdefaultRepository = userdefaultRepository
        self.router = router
        self.state = .init()
    }
    
    struct State {
        var selectedAngle: PhotoAngle? = nil
        var selectedFrame: PhotoFrame? = nil
        var selectedRatio: PhotoRatio? = nil
    }
    
    enum Input {
        case angleTap(PhotoAngle)
        case frameTap(PhotoFrame)
        case ratioTap(PhotoRatio)
        case nextButtonTap
        case xmarkTap
        case backButtonTap
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .angleTap(let photoAngle):
            state.selectedAngle = photoAngle
        case .frameTap(let photoFrame):
            state.selectedFrame = photoFrame
        case .ratioTap(let photoRatio):
            state.selectedRatio = photoRatio
        case .nextButtonTap:
            self.router.routeTo(.thirdGen(data: self.requestData()))
        case .xmarkTap:
            self.router.dismissSheet()
        case .backButtonTap:
            self.router.dismiss()
        }
    }
    
    var isFirstGenerate: Bool {
        return self.userdefaultRepository.isFirstGenerate
    }
    
    var angleOrFrameOrRatioIsEmpty: Bool {
        return state.selectedAngle == nil || state.selectedFrame == nil || state.selectedRatio == nil
    }
    
    func requestData() -> RequestImageData {
        return requestImageData.set(angle: self.state.selectedAngle,
                                    frame: self.state.selectedFrame,
                                    ratio: self.state.selectedRatio)
    }
}
