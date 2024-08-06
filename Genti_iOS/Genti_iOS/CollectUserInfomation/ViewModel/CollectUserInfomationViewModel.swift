//
//  CollectUserInfomationViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import SwiftUI

@Observable
final class CollectUserInfomationViewModel: ViewModel {
    
    let router: Router<MainRoute>
    let authRepository: AuthRepository
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    var state: State
    
    struct State {
        let years: [Int] = Array(1950...2025)
        var gender: Gender? = nil
        var birthYear: Int = 2025
        var showPicker: Bool = false
        var firstTap: Bool = false
        var showAlert: AlertType? = nil
        var isLoading: Bool = false
    }
    
    enum Input {
        case backgroundTap
        case genderSelect(Gender)
        case birthYearSelect
        case completeButtonTap
    }
    
    init(router: Router<MainRoute>, authRepository: AuthRepository) {
        self.router = router
        self.authRepository = authRepository
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .genderSelect(let gender):
            self.state.gender = gender
        case .birthYearSelect:
            if !self.state.firstTap {
                self.state.firstTap = true
                self.state.showPicker.toggle()
            } else {
                self.state.showPicker.toggle()
            }
        case .completeButtonTap:
            Task { await postUserInformation() }
        case .backgroundTap:
            if state.showPicker {
                state.showPicker = false
            }
        }
    }
    
    @MainActor
    func postUserInformation() async {
        do {
            state.isLoading = true
            guard let sex = state.gender?.description  else { return }
            try await authRepository.signIn(sex: sex, birthYear: String(describing: state.birthYear))
            userdefaultRepository.setUserRole(userRole: .complete)
            state.isLoading = false
            router.routeTo(.mainTab)
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: { self.router.popToRoot() })
                return
            }
            state.showAlert = .reportGentiError(error: error, action: {
                self.router.popToRoot()
            })
        }
    }
}

extension CollectUserInfomationViewModel {
    var birthYear: String {
        return self.state.birthYear.formatterStyle(.none)
    }
    
    func genderFont(_ gender: Gender) -> Font.PretendardType {
        if gender == self.state.gender {
            return .headline1
        }
        return .headline2
    }
    
    func genderForegoundStyle(_ gender: Gender) -> Color {
        if gender == self.state.gender {
            return .green1
        }
        return .gray2
    }
    
    var isComplete: Bool {
        return state.gender != nil && state.firstTap
    }
    
    var completeButtonFont: Font.PretendardType {
        if isComplete {
            return .headline1
        }
        return .headline2
    }
    
    var completeButtonBackground: Color {
        if isComplete {
            return .gentiGreen
        }
        return .gray6
    }
    
    var completeButtonForeground: Color {
        if isComplete {
            return .white
        }
        return .gray2
    }
}
