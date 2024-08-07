//
//  FeedRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

final class FeedRepositoryImpl: FeedRepository {

    let requestService: RequestService
    
    init(requestService: RequestService) {
        self.requestService = requestService
    }
    
    func fetchFeeds() async throws -> [FeedEntity] {
        let dto: [ExampleWithPictureFindResponseDTO] = try await requestService.fetchResponse(for: FeedRouter.requestFeed)
        return dto.map { $0.toEntity }
    }
}
