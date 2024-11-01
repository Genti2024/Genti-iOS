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
            .pretendard(.subtitle2_16_bold)
            .foregroundStyle(.white)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .trailing) {
                Image(.rightShavronNew)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 9, height: 15)
            }
            .padding(.horizontal, 16)
            .background(.black.opacity(0.001))
            .onTapGesture {
                rowTapped?()
            }
    }
}

#Preview {
    SettingRow(title: "테스트입니다")
}
