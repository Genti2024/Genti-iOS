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
    var userdefaultRepository = UserDefaultsRepositoryImpl()
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
        case openChat(fromComplete: Bool)
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
            Task { await showRequestResult() }
        case .pushReceived:
            Task { await handleUserStateFromPush() }
        case .openChat(let isFromComplete):
            Task { await handleOpenChat(isFromComplete) }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
    }

    @MainActor
    func handleOpenChat(_ isFromComplete: Bool) async {
        do {
            if userdefaultRepository.getOpenChatAgreement() {
                switch try await tabViewUseCase.checkOpenChat() {
                case .agree(let openChatInfo):
                    if isFromComplete {
                        self.router.routeTo(.recommendOpenChat(openChatInfo: openChatInfo))
                    } else {
                        self.router.dismissFullScreenCover {
                            self.router.routeTo(.recommendOpenChat(openChatInfo: openChatInfo))
                        }
                    }
                case .disagree:
                    userdefaultRepository.setOpenChatAgreement(isAgree: false)
                }
            }
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    @MainActor
    func showRequestResult() async {
        do {
            if try await tabViewUseCase.showCompleteStateWhenUserInitalAccess() {
                self.sendAction(.cameraIconTap)
            }
        } catch(let error) {
            self.handleError(error)
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
    func handleUserStateFromPush() async {
        do {
            state.isLoading = true
            switch try await tabViewUseCase.getUserState() {
            case .inProgress:
                router.routeTo(.waiting)
            case .canMake:
                router.routeTo(.firstGen)
            case .awaitUserVerification(let completePhotoEntity):
                EventLogManager.shared.logEvent(.pushNotificationTap(true))
                self.router.dismissFullScreenCover {
                    self.router.routeTo(.completeMakePhoto(photoInfo: completePhotoEntity))
                }
                
            case .canceled(let requestId):
                EventLogManager.shared.logEvent(.pushNotificationTap(false))
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
            state.showAlert = .photoRequestCanceled(action: { self.router.routeTo(.firstGen) })
        } catch(let error) {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        state.isLoading = false
        guard let error = error as? GentiError else {
            EventLogManager.shared.logEvent(.error(errorCode: "Unknowned", errorMessage: error.localizedDescription))
            state.showAlert = .reportError(action: {self.router.popToRoot()})
            return
        }
        EventLogManager.shared.logEvent(.error(errorCode: error.code, errorMessage: error.message))
        state.showAlert = .reportError(action: {self.router.popToRoot()})
    }
}
