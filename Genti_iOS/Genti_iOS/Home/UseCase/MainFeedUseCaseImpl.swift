//
//  MainFeedUseCaseImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class MainFeedUseCaseImpl: MainFeedUseCase {

    let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    func fetchFeeds() async throws -> [FeedEntity] {
        return try await feedRepository.fetchFeeds().map { $0.toEntity }
    }
}
