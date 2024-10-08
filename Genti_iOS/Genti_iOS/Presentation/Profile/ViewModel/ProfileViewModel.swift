//
//  ProfileViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

@Observable
final class ProfileViewModel: ViewModel {
    var router: Router<MainRoute>
    let profileUseCase: ProfileUseCase
    
    init(profileUseCase: ProfileUseCase, router: Router<MainRoute>) {
        self.profileUseCase = profileUseCase
        self.router = router
        self.state = .init()
    }
    
    struct State {
        var myImages: [MyImagesEntitiy] = []
        var hasInProgressImage: Bool = false
        var showAlert: AlertType? = nil
    }
    
    enum Input {
        case viewWillAppear
        case imageTap(String)
        case gearButtonTap
        case reload
    }

    var state: State
    
    func sendAction(_ input: Input) {
        switch input {
        case .imageTap(let url):
            EventLogManager.shared.logEvent(.enlargePhoto)
            router.routeTo(.photoDetailWithShare(imageUrl: url))
        case .gearButtonTap:
            router.routeTo(.setting)
        case .reload, .viewWillAppear:
            Task { await reload() }
        }
    }
    
    @MainActor
    func reload() async {
        do {
            let entity = try await profileUseCase.fetchInitalUserInfo()
            setState(entity)
        } catch(let error) {
            handleError(error)
        }
    }
    
    @MainActor
    private func setState(_ entity: UserInfoEntity) {
        state.hasInProgressImage = entity.hasInProgressPhoto
        state.myImages = entity.completedImage
    }
    
    private func handleError(_ error: Error) {
        guard let error = error as? GentiError else {
            EventLogManager.shared.logEvent(.error(errorCode: "Unknowned", errorMessage: error.localizedDescription))
            state.showAlert = .reportError(action: {self.router.popToRoot()})
            return
        }
        EventLogManager.shared.logEvent(.error(errorCode: error.code, errorMessage: error.message))
        state.showAlert = .reportError(action: {self.router.popToRoot()})
    }
}
