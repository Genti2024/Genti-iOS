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

protocol Routable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: NavigationType { get }
    func viewToDisplay(router: Router<Self>) -> ViewType
}

extension Routable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
