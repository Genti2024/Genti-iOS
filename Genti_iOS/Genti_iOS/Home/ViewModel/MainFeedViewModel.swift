//
//  MainFeedViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

@Observable
final class MainFeedViewModel: ViewModel {

    var mainFeedUseCase: MainFeedUseCase
    
    var router: Router<MainRoute>
    
    var state: MainFeedViewModel.State
    
    init(mainFeedUseCase: MainFeedUseCase, router: Router<MainRoute>) {
        self.mainFeedUseCase = mainFeedUseCase
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
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            Task {
                do {
                    state.feeds = try await mainFeedUseCase.fetchFeeds()
                } catch {
                    print(#fileID, #function, #line, "- error in feed api")
                }
            }
            
            if mainFeedUseCase.showOnboarding() {
                self.router.routeTo(.onboarding)
            }
        case .scroll(offset: let offset):
            state.isLogoHidden = offset < 165 ? true : false
        }
    }
}
