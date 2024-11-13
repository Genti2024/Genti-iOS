//
//  OnboardingStep.swift
//  Genti_iOS
//
//  Created by uiskim on 7/9/24.
//

import Foundation

enum OnboardingStep: CaseIterable {
    case first, second, third
    
    var title: String {
        return "젠티, 어떻게 사용하나요?"
    }
    
    var subtitle: String {
        switch self {
        case .first:
            return "원하는 사진을 자유롭게 설명해요."
        case .second:
            return "얼굴 사진 3장만 골라요."
        case .third:
            return "나만의 특별한 사진 완성!"
        }
    }
    
    var description: String {
        switch self {
        case .first:
            return "의상, 배경 등 어떤 사진을 만들고 싶은지 입력해주세요."
        case .second:
            return "사진 생성에 이용할 본인 사진 3장을 골라주세요."
        case .third:
            return "지금 젠티하러 가볼까요?"
        }
    }
    
    var setButtonTitle: String {
        switch self {
        case .first, .second:
            return "다음"
        case .third:
            return "젠티하러 가기"
        }
    }
}
