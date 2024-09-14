//
//  Font+.swift
//  Genti
//
//  Created by uiskim on 4/20/24.
//

import SwiftUI

/// `Funch` 서비스에서 주로 사용할 폰트 모음
enum GentiFont {
    /// `SpoqaHanSans` 폰트 모음
    enum Pretendard {
        static let bold = "Pretendard-Bold"
        static let semiBold = "Pretendard-SemiBold"
        static let regular = "Pretendard-Regular"
        static let medium = "Pretendard-Medium"
        static let light = "Pretendard-Light"
    }
}

extension Font {
    
    enum PretendardType {
        case openChatHeadline
        case openChatSubtitle
        case openChatDescription
        case openChatTitle1
        case openChatTitle2
        
        case tempHeadline
        
        case headline1
        case headline2
        case headline3
        case headline4
        case headline5
        
        case large
        case normal
        case small
        case number
        case description
        
        var value: Font {
            switch self {
            case .headline1:
                return .custom(GentiFont.Pretendard.bold, size: 22)
            case .headline2:
                return .custom(GentiFont.Pretendard.regular, size: 22)
            case .headline3:
                return .custom(GentiFont.Pretendard.light, size: 19)
            case .headline4:
                return .custom(GentiFont.Pretendard.semiBold, size: 17)
            case .headline5:
                return .custom(GentiFont.Pretendard.bold, size: 14)
            case .large:
                return .custom(GentiFont.Pretendard.light, size: 17)
            case .normal:
                return .custom(GentiFont.Pretendard.medium, size: 17)
            case .small:
                return .custom(GentiFont.Pretendard.medium, size: 14)
            case .number:
                return .custom(GentiFont.Pretendard.bold, size: 12)
            case .description:
                return .custom(GentiFont.Pretendard.light, size: 12)
            case .tempHeadline:
                return .custom(GentiFont.Pretendard.bold, size: 18)
            case .openChatHeadline:
                return .custom(GentiFont.Pretendard.bold, size: 24)
            case .openChatSubtitle:
                return .custom(GentiFont.Pretendard.regular, size: 14)
            case .openChatDescription:
                return .custom(GentiFont.Pretendard.semiBold, size: 13)
            case .openChatTitle1:
                return .custom(GentiFont.Pretendard.bold, size: 16)
            case .openChatTitle2:
                return .custom(GentiFont.Pretendard.medium, size: 16)
            }
        }
        
    }
}

extension View {
    func pretendard(_ font: Font.PretendardType) -> some View {
        return self.font(font.value)
    }
}
