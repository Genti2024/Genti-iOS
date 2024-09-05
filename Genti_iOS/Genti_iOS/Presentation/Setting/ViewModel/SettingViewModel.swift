//
//  SettingViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 8/16/24.
//

import Foundation
import Combine

@Observable
final class SettingViewModel: NSObject, ViewModel {
    var cancelBag = Set<AnyCancellable>()
    var router: Router<MainRoute>

    let settingUseCase: SettingUseCase = SettingUseCaseImpl()
    var state: State
    
    struct State {
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
    }
    
    enum Input {
        case resignAlertComformButtonTap
        case logoutAlertComformButtomTap
        case backButtonTap
        case logoutRowTap
        case resignRowTap
        case termsOfUseRowTap
        case privacyPolicyRowTap
        case businessInformationRowTap
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .resignAlertComformButtonTap:
            Task { await resign() }
        case .logoutAlertComformButtomTap:
            Task { await logout() }
        case .backButtonTap:
            router.dismiss()
        case .logoutRowTap:
            self.state.showAlert = .logout(action: { self.sendAction(.logoutAlertComformButtomTap) })
        case .resignRowTap:
            self.state.showAlert = .resign(action: { self.sendAction(.resignAlertComformButtonTap) })
        case .termsOfUseRowTap:
            self.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/5e84488cbf874b8f91e779ea4dc8f08a"))
        case .privacyPolicyRowTap:
            self.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/e0f2e17a3a60437b8e62423f61cca2a9"))
        case .businessInformationRowTap:
            self.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/39d39ae82a3a436fa053e5287ff9742c"))
        }
    }
    
    init(router: Router<MainRoute>) {
        self.router = router
        self.state = .init()
        super.init()
    }
    
    @MainActor
    func resign() async {
        defer { self.state.isLoading = false }
        do {
            self.state.isLoading = true
            try await settingUseCase.resign()
            router.popToRoot()
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    @MainActor
    func logout() async {
        defer { self.state.isLoading = false }
        do {
            self.state.isLoading = true
            try await settingUseCase.logout()
            router.popToRoot()
        } catch(let error) {
            self.handleError(error)
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
