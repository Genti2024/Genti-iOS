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
                await fetchFeed()
            }
            checkCompleteImageFromBackgroundNotification()
            checkUserFirstVisit()
        case .scroll(offset: let offset):
            state.isLogoHidden = offset < 165 ? true : false
        }
    }
    
    @MainActor
    func fetchFeed() async {
        defer { state.isLoading = false }
        do {
            state.isLoading = true
            state.feeds = try await feedRepository.fetchFeeds()
            
            // MARK: - bool이 아니라 구조체를 넣자
        } catch(let error) {
            print(#fileID, #function, #line, "- \(error.localizedDescription)")
        }
    }
    
    func checkCompleteImageFromBackgroundNotification() {
        guard let isShow = userDefaultsRepository.get(forKey: .showImage) as? Bool else { return }
        if isShow {
            router.routeTo(.completeMakeImage(imageInfo: .init()))
            userDefaultsRepository.remove(forKey: .showImage)
        }
    }
    
    func checkUserFirstVisit() {
        if userDefaultsRepository.isFirstVisitApp {
            self.router.routeTo(.onboarding)
        }
    }
}
