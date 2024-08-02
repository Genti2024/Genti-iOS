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
        var page: Int = 0
        var myImages: [MyImagesEntitiy.Image] = []
        var isLastPage: Bool = false
        var hasInProgressImage: Bool = false
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
    }
    enum Input {
        case viewWillAppear
        case reachBottom
        case imageTap(String)
        case gearButtonTap
    }

    var state: State
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            Task { await setInitalState() }
        case .reachBottom:
            Task { await myImagePagination() }
        case .imageTap(let url):
            Task { await showMyImage(url: url) }
        case .gearButtonTap:
            router.routeTo(.setting)
        }
    }
    
    @MainActor
    func setInitalState() async {
        do {
            state.isLoading = true
            state.page = 0
            state.myImages = []
            state.isLastPage = false
            state.hasInProgressImage = false
            let entity = try await profileUseCase.fetchInitalUserInfo()
            state.hasInProgressImage = entity.hasInProgressPhoto
            state.myImages = entity.completedImage.images
            state.isLastPage = entity.completedImage.isLast
            state.isLoading = false
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }
    
    @MainActor
    func myImagePagination() async {
        do {
            guard !state.isLastPage else { return }
            state.page += 1
            let entity = try await profileUseCase.getCompletedPhotos(page: state.page)
            state.myImages += entity.images
            state.isLastPage = entity.isLast
        } catch(let error) {
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }
    
    @MainActor
    func showMyImage(url: String) async {
        do {
            guard let image = await profileUseCase.load(from: url) else { return }
            router.routeTo(.photoDetailWithShare(image: image))
        }
    }
}
