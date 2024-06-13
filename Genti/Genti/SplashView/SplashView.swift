//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var mainNavigation: GentiMainNavigation
    var body: some View {
        ZStack {
            // Background Color
            Color.gentiGreen
                .ignoresSafeArea()
            // Content
            
        } //:ZSTACK
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.mainNavigation.push(.login)
            }
        }
    }
}

#Preview {
    SplashView()
}
