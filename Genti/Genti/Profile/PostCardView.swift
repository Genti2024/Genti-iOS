//
//  PostCardView.swift
//  Genti
//
//  Created by uiskim on 5/30/24.
//

import SwiftUI

struct PostCardView: View {
    
    var post: Post
    
    var body: some View {
        Image(post.imageURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    PostCardView(post: .init(imageURL: "SampleImage32"))
}
