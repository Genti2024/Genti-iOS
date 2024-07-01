//
//  Constants.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import Foundation
import UIKit

enum Constants {
    static let randomImage = "https://picsum.photos/600/600"
    
    static func text(length: Int) -> String {
        return String(repeating: "테", count: length)
    }
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}
