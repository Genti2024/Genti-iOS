//
//  TabViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 8/2/24.
//

import Foundation

@Observable
final class TabViewModel: ViewModel {
    
    var tabViewUseCase: TabViewUseCase
    var router: Router<MainRoute>
    
    var state: State
    struct State {
        var currentTab: Tab = .feed
        
    }
    enum Input {
        case feedIconTap
        case profileIconTap
        case cameraIconTap
    }
    func sendAction(_ input: Input) {
        switch input {
        case .feedIconTap:
            state.currentTab = .feed
        case .profileIconTap:
            state.currentTab = .profile
        case .cameraIconTap:
            Task {
                switch try await tabViewUseCase.getUserState() {
                case .inProgress:
                    router.routeTo(.waiting)
                case .canMake:
                    router.routeTo(.firstGen)
                case .awaitUserVerification(let completePhotoEntity):
                    router.routeTo(.completeMakeImage(imageInfo: completePhotoEntity))
                case .canceled(let requestId):
                    // MARK: - 취소되었을떄
                    Task {
                        do {
                            try await tabViewUseCase.checkCanceledImage(requestId: requestId)
                        } catch(let error) {
                            print(error)
                        }
                    }
                    router.routeTo(.firstGen)
                case .error:
                    print(#fileID, #function, #line, "- 에러발생")
                }
            }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
    }
    
}
