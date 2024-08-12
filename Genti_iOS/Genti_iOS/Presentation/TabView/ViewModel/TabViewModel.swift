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
        case viewWillAppear
        case pushReceived
    }
    func sendAction(_ input: Input) {
        switch input {
        case .feedIconTap:
            state.currentTab = .feed
        case .profileIconTap:
            state.currentTab = .profile
        case .cameraIconTap:
            Task { await handleUserState() }
        case .viewWillAppear:
            Task { await handleCanceledCase() }
        case .pushReceived:
            router.dismissSheet { self.router.routeTo(.completeMakePhoto(photoInfo: .init())) }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
    }
    
    @MainActor
    func handleCanceledCase() async {
        do {
            let cancelState = try await tabViewUseCase.hasCanceledCase()
            if cancelState.canceled {
                guard let requestId = cancelState.requestId else { return }
                await handleCanceledState(requestId: requestId)
            }
        } catch(let error) {
            handleError(error)
        }

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
                state.showAlert = .photoCompleted(action: { self.router.routeTo(.completeMakePhoto(photoInfo: completePhotoEntity))})
            case .canceled(let requestId):
                await handleCanceledState(requestId: requestId)
            case .error:
                state.showAlert = .reportGentiError(error: GentiError.serverError(code: "오류", message: "예상치못한 유저상태입니다"), action: nil)
            }
            state.isLoading = false
        } catch(let error) {
            handleError(error)
        }
    }

    @MainActor
    func handleCanceledState(requestId: Int) async {
        do {
            try await tabViewUseCase.checkCanceledImage(requestId: requestId)
            state.showAlert = .photoRequestCanceled(action: {self.router.routeTo(.firstGen)})
        } catch(let error) {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        state.isLoading = false
        guard let error = error as? GentiError else {
            state.showAlert = .reportUnknownedError(error: error, action: nil)
            return
        }
        state.showAlert = .reportGentiError(error: error, action: nil)
    }
}
