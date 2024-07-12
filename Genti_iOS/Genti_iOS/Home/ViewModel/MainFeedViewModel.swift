//
//  MainFeedViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

@Observable
final class MainFeedViewModel: ViewModel {

    let feedRepository: FeedRepository
    let userDefaultsRepository: UserDefaultsRepository
    
    var router: Router<MainRoute>
    
    var state: MainFeedViewModel.State
    
    init(feedRepository: FeedRepository, userDefaultsRepository: UserDefaultsRepository, router: Router<MainRoute>) {
        self.feedRepository = feedRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.router = router
        self.state = .init()
    }
    
    enum Input {
        case viewWillAppear
        case scroll(offset: Double)
    }
    
    struct State {
        var feeds: [FeedEntity] = []
        var isLogoHidden: Bool = false
        var isLoading: Bool = false
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            Task {
                do {
                    state.isLoading = true
                    state.feeds = try await feedRepository.fetchFeeds()
                    state.isLoading = false
                } catch {
                    print(#fileID, #function, #line, "- error in feed api")
                }
            }
            
            if userDefaultsRepository.isFirstVisit {
                self.router.routeTo(.onboarding)
            }
        case .scroll(offset: let offset):
            state.isLogoHidden = offset < 165 ? true : false
        }
    }
}
