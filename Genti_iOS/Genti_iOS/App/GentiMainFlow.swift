//
//  GentiMainFlow.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

final class GentiMainFlow: ObservableObject {
    @Published var path: [AppFlow] = []
    
    func push(_ flow: AppFlow) {
        self.path.append(flow)
    }
    
    func back() {
        self.path.removeLast()
    }
    
    func popToRoot() {
        self.path.removeAll()
    }
}
