//
//  MainFeedUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

protocol MainFeedUseCase {
    func fetchFeeds() async throws -> [FeedEntity]
}
