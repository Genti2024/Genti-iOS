//
//  GentiApp.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI

@main
struct GentiApp: App {
    @StateObject var viewModel: GeneratorViewModel = GeneratorViewModel()
    var body: some Scene {
        WindowGroup {
            
            FirstGeneratorView()
                .environmentObject(viewModel)
        }
    }
}
