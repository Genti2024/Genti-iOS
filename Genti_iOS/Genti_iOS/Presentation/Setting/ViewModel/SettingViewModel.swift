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
    let requestService: RequestService = RequestServiceImpl()
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
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
        
        self.settingUseCase.kakaoResignCompleteSubject.merge(with: self.settingUseCase.appleResignCompleteSubject
            .delay(for: .seconds(0.5), scheduler: RunLoop.main))
            .sink { _ in router.popToRoot() }
            .store(in: &self.cancelBag)
        
        self.settingUseCase.isLoading
            .sink { self.state.isLoading = $0 }
            .store(in: &self.cancelBag)
        
        self.settingUseCase.errorSubject
            .sink { gentError in
                self.state.showAlert = .reportGentiError(error: gentError, action: nil)
            }
            .store(in: &self.cancelBag)
    }
    
    @MainActor
    func resign() async {
        do {
            try await settingUseCase.resign()
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    @MainActor
    func logout() async {
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
            state.showAlert = .reportUnknownedError(error: error, action: nil)
            return
        }
        state.showAlert = .reportGentiError(error: error, action: nil)
    }
}
