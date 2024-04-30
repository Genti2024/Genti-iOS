//
//  BulletText.swift
//  Genti
//
//  Created by uiskim on 4/30/24.
//

import SwiftUI

struct BulletText: View {
    let bulletListGridItems = [
        GridItem(.fixed(10)),
        GridItem()
    ]
    
    let text: String
    
    var body: some View {
        LazyVGrid(columns: bulletListGridItems, alignment: .leading, content: {
            GridRow {
                VStack(alignment: .leading, content: {
                    Text("•")
                        .pretendard(.description)
                        .foregroundStyle(.gray3)
                    Spacer()
                })
                Text(text)
                    .pretendard(.description)
                    .foregroundStyle(.gray3)
            }
        }
        )
    }
}


#Preview {
    BulletText(text: Caution.texts[0])
}
