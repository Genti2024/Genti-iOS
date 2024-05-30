//
//  MadeImage.swift
//  Genti
//
//  Created by uiskim on 5/30/24.
//

import Foundation

struct Post: Identifiable, Hashable {
    let id = UUID().uuidString
    var imageURL: String
    
    static var dummies: [Post] {
        return [Post(imageURL: "SampleImage32"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage32"),
                Post(imageURL: "SampleImage32"),
                Post(imageURL: "SampleImage32"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage23"),
                Post(imageURL: "SampleImage32"),
                Post(imageURL: "SampleImage32")]
    }
}
