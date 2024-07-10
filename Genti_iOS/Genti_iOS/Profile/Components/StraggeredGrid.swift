//
//  StraggeredGrid.swift
//  Genti
//
//  Created by uiskim on 5/30/24.
//

import SwiftUI

struct StraggeredGrid<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var columns: Int = 2
    var spacing: CGFloat
    
    struct Column: Identifiable {
        let id: Int
        var items: [T]
    }
    
    func setUpList() -> [Column] {
        var gridArray: [Column] = []
        
        for index in 0..<columns {
            gridArray.append(Column(id: index, items: []))
        }
        
        var currentIndex = 0
        for object in list {
            gridArray[currentIndex].items.append(object)
            currentIndex = (currentIndex + 1) % columns
        }
        
        return gridArray
    }

    init(list: [T], spacing: CGFloat, @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(setUpList()) { columnData in
                        LazyVStack(spacing: spacing) {
                            ForEach(columnData.items) { object in
                                content(object)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .background {
            BlurView(style: .light)
                .overlay(alignment: .center) {
                    if list.isEmpty {
                        VStack(spacing: 37) {
                            Image("ExclamationImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 43)
                            
                            Text("아직 내가 만든 사진이 없어요")
                                .pretendard(.headline1)
                                .foregroundStyle(.gray3)
                        }
                    }
                }
        }
    }
}
