//
//  HomeView.swift
//  Genti
//
//  Created by uiskim on 5/25/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FeedView()
                FeedView(description: Constants.text(length: 100))
                
                FeedView(description: Constants.text(length: 100))
                
            } //:VSTACK
        }
    }
}

#Preview {
    HomeView()
}
