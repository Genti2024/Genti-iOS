//
//  Feed.swift
//  Genti
//
//  Created by uiskim on 4/20/24.
//

import Foundation

struct FeedEntity: Identifiable {
    var id: Int
    let imageUrl: String
    let description: String
    var ratio: PhotoRatio
}
