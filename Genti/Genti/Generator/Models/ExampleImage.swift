//
//  ExampleImage.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import Foundation

struct ExampleImage: Identifiable {
    let id: String = UUID().uuidString
    var imageName: String
    
    static var mocks: [ExampleImage] {
        return [
            .init(imageName: "Example1"),
            .init(imageName: "Example2"),
            .init(imageName: "Example1")
        ]
    }
}
