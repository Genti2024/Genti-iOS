//
//  SecondGeneratorView.swift
//  Genti
//
//  Created by uiskim on 4/18/24.
//

import SwiftUI

struct SecondGeneratorView: View {
    
    var onXmarkPressed: (() -> Void)? = nil
    
    var body: some View {
        Button {
            // Action
            onXmarkPressed?()
        } label: {
            Text("닫기")
        }
    }
}

#Preview {
    SecondGeneratorView()
}
