//
//  ContentView.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            Text("사진 생성하기")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 60)
                .background(.green1)
        } //:ZSTACK
    }
}

#Preview {
    ContentView()
}
