//
//  Feed.swift
//  Genti
//
//  Created by uiskim on 4/20/24.
//

import Foundation

struct Feed: Identifiable {
    let id: String = UUID().uuidString
    let mainImage: String
    let description: String
    
    static let mocks: [Feed] = [
        .init(mainImage: "SampleImage32", description: Constants.text(length: 50)),
        .init(mainImage: "SampleImage23", description: Constants.text(length: 20)),
        .init(mainImage: "SampleImage23", description: Constants.text(length: 80)),
        .init(mainImage: "SampleImage32", description: Constants.text(length: 40)),
        .init(mainImage: "SampleImage23", description: Constants.text(length: 120)),
        .init(mainImage: "SampleImage23", description: Constants.text(length: 14)),
        .init(mainImage: "SampleImage32", description: Constants.text(length: 54)),
        .init(mainImage: "SampleImage23", description: Constants.text(length: 200))
    ]
}
