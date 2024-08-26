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
            // 만약에 유저가 백그라운드에서 push를 안누른 경우
            // 앱에진입했을때 userdefault에 background푸시 flag가 false인데(push가 왔는데 확인X) 유저상태가 await 혹은 canceled인 경우
            // -> 자동으로 앱실행시 완료뷰 혹은 취소뷰를 보여줘야한다
            Task { await showRequestResult() }
        case .pushReceived:
            // 유저가 푸시를 누른 경우
            Task { await handleUserStateFromPush() }
        }
    }
    
    init(tabViewUseCase: TabViewUseCase, router: Router<MainRoute>) {
        self.tabViewUseCase = tabViewUseCase
        self.router = router
        self.state = .init()
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
                self.router.dismissSheet {
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
            state.showAlert = .reportUnknownedError(error: error, action: nil)
            return
        }
        state.showAlert = .reportGentiError(error: error, action: nil)
    }
}
