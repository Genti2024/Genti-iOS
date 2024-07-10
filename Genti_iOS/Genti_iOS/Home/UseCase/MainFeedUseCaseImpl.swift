//
//  MainFeedUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class MainFeedUseCaseImpl: MainFeedUseCase {

    

    let feedRepository: FeedRepository
    let userDefaultsRepository: UserDefaultsRepository
    
    init(feedRepository: FeedRepository, userDefaultsRepository: UserDefaultsRepository) {
        self.feedRepository = feedRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func fetchFeeds() async throws -> [FeedEntity] {
        return try await feedRepository.fetchFeeds().map { $0.toEntity }
    }
    
    func showOnboarding() -> Bool {
        guard let isShow = userDefaultsRepository.get(forKey: .isFirst) as? Bool else {
            // 처음들어온것
            userDefaultsRepository.set(to: false, forKey: .isFirst)
            return true
        }
        return isShow
    }
    
}
