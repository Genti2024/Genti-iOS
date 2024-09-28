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
        case .cameraIconTap, .pushReceived:
            Task { await handleUserState() }
        case .viewWillAppear:
            Task { await handleBackgroundPush() }
        case .openChat:
            Task { await handleOpenChat() }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
    }

    @MainActor
    func handleOpenChat() async {
        do {
            if userdefaultRepository.getOpenChatAgreement() {
                switch try await tabViewUseCase.checkOpenChat() {
                case .agree(let openChatInfo):
                    self.router.dismissFullScreenCover {
                        self.router.routeTo(.recommendOpenChat(openChatInfo: openChatInfo))
                    }
                case .disagree:
                    userdefaultRepository.setOpenChatAgreement(isAgree: false)
                }
            }
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    // 백그라운드에서 푸시가 왔는지를 판단
    @MainActor
    func handleBackgroundPush() async {
        do {
            switch try await tabViewUseCase.getSavedBackgroundPush() {
            case .requestComplete:
                self.sendAction(.cameraIconTap)
            case .openChat:
                await self.handleOpenChat()
            case .none:
                return
            }
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    @MainActor
    func handleUserState() async {
        do {
            switch try await tabViewUseCase.checkInspectionTime() {
            case .canMake:
                switch try await tabViewUseCase.getUserState() {
                case .inProgress:
                    self.router.dismissFullScreenCover { self.router.routeTo(.waiting) }
                case .canMake:
                    self.router.dismissFullScreenCover { self.router.routeTo(.firstGen) }
                case .awaitUserVerification(let completePhotoEntity):
                    EventLogManager.shared.logEvent(.pushNotificationTap(true))
                    self.router.dismissFullScreenCover { self.router.routeTo(.completeMakePhoto(photoInfo: completePhotoEntity)) }
                case .canceled(let requestId):
                    EventLogManager.shared.logEvent(.pushNotificationTap(false))
                    await handleCanceledState(requestId: requestId)
                case .error:
                    state.showAlert = .reportGentiError(error: GentiError.serverError(code: "오류", message: "예상치못한 유저상태입니다"), action: nil)
                }
            case .cantMake(let title):
                self.state.showAlert = .InspectionTime(title: title)
            }

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
        guard let error = error as? GentiError else {
            EventLogManager.shared.logEvent(.error(errorCode: "Unknowned", errorMessage: error.localizedDescription))
            state.showAlert = .reportError(action: {self.router.popToRoot()})
            return
        }
        EventLogManager.shared.logEvent(.error(errorCode: error.code, errorMessage: error.message))
        state.showAlert = .reportError(action: {self.router.popToRoot()})
    }
}
