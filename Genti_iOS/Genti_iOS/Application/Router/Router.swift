//
//  Router.swift
//  Genti_iOS
//
//  Created by uiskim on 6/16/24.
//

import SwiftUI

@Observable 
final class Router<Destination: Route> {

    public var path: NavigationPath = NavigationPath()
    public var presentingFullScreenCover: Destination?
    var isPresented: Binding<Destination?> = .constant(.none)
    
    @ViewBuilder
    public func view(from route: Destination) -> some View {
        route.view(from: router(routeType: route.navigationType))
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
        path.removeLast(path.count-1)
    }
    
    public func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func dismissSheet() {
        isPresented.wrappedValue = nil
    }
    
    public func dismissSheet(_ handler: @escaping () -> Void) {
        if let _ = self.isPresented.wrappedValue {
            self.isPresented.wrappedValue = nil
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                handler()
            }
            return
        }
        handler()
    }
    
    public func dismissFullScreenCover(_ handler: @escaping () -> Void) {
        if let _ = self.presentingFullScreenCover {
            self.presentingFullScreenCover = nil
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                handler()
            }
            return
        }
        handler()
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
