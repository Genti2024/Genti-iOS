//
//  CollectUserInfomationViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import SwiftUI

@Observable
final class SignInViewModel: ViewModel {
    
    let signInUseCase: SignInUseCase
    
    let router: Router<MainRoute>
    
    var state: State
    
    struct State {
        var gender: Gender? = nil
        var birthYear: String? = nil
        var showAlert: AlertType? = nil
        var isLoading: Bool = false
    }
    
    enum Input {
        case viewWillAppear
        case genderSelect(Gender)
        case completeButtonTap
    }
    
    init(signInUseCase: SignInUseCase, router: Router<MainRoute>) {
        self.signInUseCase = signInUseCase
        self.router = router
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            EventLogManager.shared.logEvent(.viewInfoget)
        case .genderSelect(let gender):
            self.state.gender = gender
        case .completeButtonTap:
            Task { await postUserInformation() }
        }
    }
    
    @MainActor
    func postUserInformation() async {
        do {
            state.isLoading = true
            guard let birthYear = state.birthYear else { return }
            try await signInUseCase.signIn(gender: state.gender, birthYear: Int(birthYear)!)
            state.isLoading = false
            router.routeTo(.mainTab)
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

extension SignInViewModel {
    var isActive: Bool {
        return state.gender != nil && state.birthYear?.count == 4
    }
}
