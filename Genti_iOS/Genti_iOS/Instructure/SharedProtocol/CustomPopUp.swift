//
//  CustomPopUp.swift
//  Genti_iOS
//
//  Created by uiskim on 7/22/24.
//

import SwiftUI

import PopupView

/// CustomPopup 프로토콜은 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
protocol CustomPopup {
    associatedtype Content: View
    /// contentView는 View라는 프로토콜을 채택한 어떤 종류의 객체라도 가능하다.
    var contentView: Content { get }
    /// 이렇게 받은 contentView를 가지고 custom할 것이기 때문에 여기는 어떤 뷰가 들어올지 모르니까 AnyView로 감싼다.
    /// 결국 contentView를 나중에는 AnyView로 만들어줘야 한다.
    /// 이렇게 한 이유는 popup을 만드는 사람 입장에서는 AnyView를 쓴다는 걸 모르게 하는 게 훨씬 편하기 때문.
    /// 즉, 그냥 Custom View를 받고 내부적으로 AnyView를 만들어서 customize해준다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters { get }
}
