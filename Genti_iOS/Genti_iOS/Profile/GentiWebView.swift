//
//  GentiWebView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct GentiWebView: View {
    @Bindable var router: Router<MainRoute>
    let urlString: String
    
    var body: some View {
        ZStack {
            // Background Color
            Color.white
                .ignoresSafeArea()
                
            // Content
            VStack(spacing: 20) {
                Image("Genti_LOGO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 30)
                    .overlay(alignment: .leading) {
                        Image("Back_fill")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .padding(.leading, 30)
                            .onTapGesture {
                                router.dismiss()
                            }
                    }
                WebView(urlString: urlString)
                    .ignoresSafeArea()
            }
            
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    GentiWebView(router: .init(), urlString: "https://stealth-goose-156.notion.site/5e84488cbf874b8f91e779ea4dc8f08a")
}
