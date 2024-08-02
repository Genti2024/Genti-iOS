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
    var photoInfo: CompletePhotoEntity

    init(userRepository: UserRepository, photoInfo: CompletePhotoEntity) {
        self.userRepository = userRepository
        self.photoInfo = photoInfo
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
        defer {
            state.isLoading = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ratingCompleted"), object: nil)
        }
        do {
            self.state.isLoading = true
            try await userRepository.scorePhoto(responseId: photoInfo.responseId, rate: state.rating)
        } catch(let error) {
            print(error)
        }
    }
}
