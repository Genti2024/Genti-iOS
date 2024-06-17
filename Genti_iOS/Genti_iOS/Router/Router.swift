//
//  Router.swift
//  Genti_iOS
//
//  Created by uiskim on 6/16/24.
//

import SwiftUI

@Observable final class Router<Destination: Routable> {

    public var path: NavigationPath = NavigationPath()
    public var presentingFullScreenCover: Destination?
    var isPresented: Binding<Destination?> = .constant(.none)
    
    @ViewBuilder public func view(for route: Destination) -> some View {
        route.viewToDisplay(router: router(routeType: route.navigationType))
    }
    
    public func routeTo(_ route: Destination) {
        switch route.navigationType {
        case .push:
            push(route)
        case .fullScreenCover:
            presentFullScreen(route)
        }
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func dismissSheet() {
        isPresented.wrappedValue = nil
    }
    
    private func push(_ appRoute: Destination) {
        path.append(appRoute)
    }
    
    private func presentFullScreen(_ route: Destination) {
        self.presentingFullScreenCover = route
    }
    
    private func router(routeType: NavigationType) -> Router {
        switch routeType {
        case .push:
            return self            
        case .fullScreenCover:
            let router = Router()
            router.isPresented = Binding(
                get: { self.presentingFullScreenCover },
                set: { self.presentingFullScreenCover = $0 }
            )
            return router
        }
    }
}
