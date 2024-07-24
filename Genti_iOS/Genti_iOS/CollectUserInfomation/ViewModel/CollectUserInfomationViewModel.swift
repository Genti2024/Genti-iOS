//
//  CollectUserInfomationViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import SwiftUI

@Observable
final class CollectUserInfomationViewModel: ViewModel {
    
    var state: State
    
    struct State {
        let years: [Int] = Array(1970...2025)
        var gender: Gender? = nil
        var birthYear: Int = 2025
        var showPicker: Bool = false
        var firstTap: Bool = false
    }
    
    enum Input {
        case backgroundTap
        case genderSelect(Gender)
        case birthYearSelect
        case completeButtonTap
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
            print(#fileID, #function, #line, "- tap")
            print("성별은 \(state.gender!.description)이고")
            print("태어난 년도는 \(self.birthYear)년 입니다")
        case .backgroundTap:
            if state.showPicker {
                state.showPicker = false
            }
        }
    }
    
    init() {
        self.state = .init()
    }
    
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
