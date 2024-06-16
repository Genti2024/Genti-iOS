//
//  GentiMainFlow.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

enum MainFlow: Hashable {
    case login
    case home
    case setting
    case notion(urlString: String)
}


final class GentiMainFlow: ObservableObject {
    @Published var mainPath: [MainFlow] = []

    
    @Published var selectedPost: Post? = nil
    @Published var receiveNoti: Bool = false
    @Published var showGeneratorView: Bool = false
    
    var hasCompleted: Bool = false
    
    func push(_ flow: MainFlow) {
        self.mainPath.append(flow)
    }
    
    
    func back() {
        self.mainPath.removeLast()
    }

    private var transaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = true
        return t
    }
    func popToRoot() {
        withTransaction(transaction) {
            self.mainPath.removeAll()
        }
        
        
    }
}
