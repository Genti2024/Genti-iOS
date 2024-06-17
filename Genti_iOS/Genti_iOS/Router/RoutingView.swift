//
//  RoutingView.swift
//  Genti_iOS
//
//  Created by uiskim on 6/16/24.
//

import SwiftUI

struct RoutingView<Content: View, Destination: Routable>: View {
    @State var router: Router<Destination>
    private let rootContent: (Router<Destination>) -> Content
    
    public init(_ router: Router<Destination>, @ViewBuilder content: @escaping (Router<Destination>) -> Content) {
        self.router = router
        self.rootContent = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            rootContent(router)
                .navigationDestination(for: Destination.self) { route in
                    router.view(for: route)
                }
        }
        .fullScreenCover(item: $router.presentingFullScreenCover) { route in
                router.view(for: route)
        }
    }
}
