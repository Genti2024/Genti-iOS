//
//  RatingAlertViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

@Observable
final class RatingAlertViewModel: ViewModel {
    
    var userRepository: UserRepository
    
    struct State {
        var rating: Int = 0
        var isLoading: Bool = false
    }
    
    enum Input {
        case ratingViewSkipButtonTap
        case ratingViewSubmitButtonTap
        case ratingViewStarTap(rating: Int)
    }
    
    var state: State
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .ratingViewSkipButtonTap:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ratingCompleted"), object: nil)
        case .ratingViewSubmitButtonTap:
            Task { await submitRating() }
        case .ratingViewStarTap(let rating):
            self.state.rating = rating
        }
    }
    
    @MainActor
    func submitRating() async {
        do {
            self.state.isLoading = true
            try await userRepository.scorePhoto(rate: state.rating)
            self.state.isLoading = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ratingCompleted"), object: nil)
        } catch {
            
        }
    }
}
