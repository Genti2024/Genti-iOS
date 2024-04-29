//
//  Text+.swift
//  Genti
//
//  Created by uiskim on 4/20/24.
//

import SwiftUI

extension Text {
    func pretendard(_ font: Font.PretendardType) -> some View {
        return self.font(font.value)
    }
}