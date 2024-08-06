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
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
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
                await handleUserState()
            }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
    }
    
    @MainActor
    func handleUserState() async {
        do {
            state.isLoading = true
            switch try await tabViewUseCase.getUserState() {
            case .inProgress:
                router.routeTo(.waiting)
            case .canMake:
                router.routeTo(.firstGen)
            case .awaitUserVerification(let completePhotoEntity):
                state.showAlert = .photoCompleted(action: { self.router.routeTo(.completeMakeImage(imageInfo: completePhotoEntity))})
            case .canceled(let requestId):
                await handleCanceledState(requestId: requestId)
            case .error:
                state.showAlert = .reportGentiError(error: GentiError.serverError(code: "오류", message: "예상치못한 유저상태입니다"), action: nil)
            }
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
    func handleCanceledState(requestId: Int) async {
        do {
            try await tabViewUseCase.checkCanceledImage(requestId: requestId)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "profileReload"), object: nil)
            state.showAlert = .photoRequestCanceled(action: {self.router.routeTo(.firstGen)})
            
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }
    
}
