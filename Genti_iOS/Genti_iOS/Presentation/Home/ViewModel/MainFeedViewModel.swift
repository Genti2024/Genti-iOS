//
//  MainFeedViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

@Observable
final class MainFeedViewModel: ViewModel {

    private enum ScrollThresholds {
        static let logoHideOffset: Double = 165
        static let feedScrollStartOffset: Double = -1300
    }

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
        case genfluencerExplainTap
        case refresh
    }

    struct State {
        var feeds: [FeedEntity] = []
        var isLogoHidden: Bool = false
        var isLoading: Bool = false
        var showAlert: AlertType? = nil
    }

    private var hasScrolledPastThreshold: Bool = false {
        didSet {
            if hasScrolledPastThreshold {
                print(#fileID, #function, #line, "- 유저 스크롤 저장")
                EventLogManager.shared.addUserPropertyCount(to: .scrollMainView)
                EventLogManager.shared.logEvent(.scrollMainView)}
            }
        }

    func sendAction(_ input: Input) {
        switch input {
        case .viewWillAppear:
            Task { await fetchFeed() }
            checkCompleteImageFromBackgroundNotification()
            checkUserFirstVisit()
        case .scroll(offset: let offset):
            handleScroll(offset: offset)
        case .genfluencerExplainTap:
            router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/57a00e1d610b4c1786c6ab1fdb4c4659?pvs=4"))
        case .refresh:
            EventLogManager.shared.addUserPropertyCount(to: .refreshMainView)
            EventLogManager.shared.logEvent(.refreshMainView)
            state.feeds = state.feeds.shuffled()
        }
    }

    @MainActor
    func fetchFeed() async {
        do {
            state.isLoading = true
            state.feeds = try await feedRepository.fetchFeeds()
            state.isLoading = false
        } catch(let error) {
            state.isLoading = false
            guard let error = error as? GentiError else {
                state.showAlert = .reportUnknownedError(error: error, action: nil)
                return
            }
            state.showAlert = .reportGentiError(error: error, action: nil)
        }
    }

    func checkCompleteImageFromBackgroundNotification() {
        guard let isShow = userDefaultsRepository.get(forKey: .showImage) as? Bool else { return }
        if isShow {
            router.routeTo(.completeMakePhoto(photoInfo: .init()))
            userDefaultsRepository.remove(forKey: .showImage)
        }
    }

    func checkUserFirstVisit() {
        if userDefaultsRepository.isFirstVisitApp {
            self.router.routeTo(.onboarding)
        }
    }

    private func handleScroll(offset: Double) {
        state.isLogoHidden = offset < ScrollThresholds.logoHideOffset
        
        let hasScrolledPastThreshold = offset < ScrollThresholds.feedScrollStartOffset
        if self.hasScrolledPastThreshold != hasScrolledPastThreshold {
            self.hasScrolledPastThreshold = hasScrolledPastThreshold
        }
    }
}
