//
//  Routable.swift
//  Genti_iOS
//
//  Created by uiskim on 6/16/24.
//

import SwiftUI

enum NavigationType {
    case push
    case fullScreenCover
}

protocol Route: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: NavigationType { get }
    func view(from router: Router<Self>) -> ViewType
}

extension Route {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
