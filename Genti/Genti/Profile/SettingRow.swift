//
//  SettingRow.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct SettingRow: View {
    
    var title: String
    var rowTapped: (()->Void)? = nil
    
    var body: some View {
        Text(title)
            .pretendard(.normal)
            .foregroundStyle(.black)
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .background(.black.opacity(0.001))
            .onTapGesture {
                rowTapped?()
            }
    }
}

#Preview {
    SettingRow(title: "테스트입니다")
}
