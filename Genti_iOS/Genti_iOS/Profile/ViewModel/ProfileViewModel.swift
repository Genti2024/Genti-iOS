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
            Task {
                do {
                    state.page = 0
                    state.myImages = []
                    state.isLastPage = false
                    state.hasInProgressImage = false
                    let entity = try await profileUseCase.fetchInitalUserInfo()
                    state.hasInProgressImage = entity.hasInProgressPhoto
                    state.myImages = entity.completedImage.images
                    state.isLastPage = entity.completedImage.isLast
                } catch {
                    
                }
            }
        case .reachBottom:
            Task {
                do {
                    guard !state.isLastPage else { return }
                    state.page += 1
                    let entity = try await profileUseCase.getCompletedPhotos(page: state.page)
                    state.myImages += entity.images
                    state.isLastPage = entity.isLast
                } catch {
                    
                }
            }
            
        case .imageTap(let url):
            Task {
                do {
                    guard let image = await profileUseCase.load(from: url) else { return }
                    await MainActor.run {
                        router.routeTo(.photoDetailWithShare(image: image))
                    }
                }
            }
            
        case .gearButtonTap:
            router.routeTo(.setting)
        }
    }
}
