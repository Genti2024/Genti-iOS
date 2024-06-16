//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import SDWebImageSwiftUI

struct SplashView: View {
    @EnvironmentObject var mainFlow: GentiMainFlow

    var body: some View {
        ZStack {
            AnimatedImage(name: "Genti_Splash.gif")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.mainFlow.push(.login)
            }
        }
    }
}
