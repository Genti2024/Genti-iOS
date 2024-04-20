//
//  Feed.swift
//  Genti
//
//  Created by uiskim on 4/20/24.
//

import Foundation

struct Feed: Identifiable {
    let id: String = UUID().uuidString
    let profileImage: String = Constants.randomImage
    let userName: String
    let mainImage: String
    let description: String
    
    static let mocks: [Feed] = [
        .init(userName: "My_Youth4", mainImage: "SampleImage32", description: Constants.text(length: 50)),
        .init(userName: "My_Youth1", mainImage: "SampleImage23", description: Constants.text(length: 20)),
        .init(userName: "My_Youth2", mainImage: "SampleImage23", description: Constants.text(length: 80)),
        .init(userName: "My_Youth3", mainImage: "SampleImage32", description: Constants.text(length: 40)),
        .init(userName: "My_Youth5", mainImage: "SampleImage23", description: Constants.text(length: 120)),
        .init(userName: "My_Youth6", mainImage: "SampleImage23", description: Constants.text(length: 14)),
        .init(userName: "My_Youth7", mainImage: "SampleImage32", description: Constants.text(length: 54)),
        .init(userName: "My_Youth8", mainImage: "SampleImage23", description: Constants.text(length: 100))
    ]
}
