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
        case .viewWillAppear:
            Task { await setInitalState() }
        case .imageTap(let url):
            Task { await showMyImage(url: url) }
        case .gearButtonTap:
            router.routeTo(.setting)
        case .reload:
            Task { await reload() }
        }
    }
    
    @MainActor
    func setInitalState() async {
        do {
            let entity = try await profileUseCase.fetchInitalUserInfo()
            setState(entity)
        } catch(let error) {
            handleError(error)
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
    func showMyImage(url: String) async {
        do {
            guard let image = await profileUseCase.load(from: url) else { return }
            router.routeTo(.photoDetailWithShare(image: image))
        }
    }
    
    private func setState(_ entity: UserInfoEntity) {
        state.hasInProgressImage = entity.hasInProgressPhoto
    }
    
    private func handleError(_ error: Error) {
        guard let error = error as? GentiError else {
            state.showAlert = .reportUnknownedError(error: error, action: nil)
            return
        }
        state.showAlert = .reportGentiError(error: error, action: nil)
    }
}
