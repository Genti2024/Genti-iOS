//
//  AlertType.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

enum AlertType {
    
    typealias AlertAction = (()->Void)
    
    case report(action: AlertAction, placeholder: String, text: Binding<String>)
    case reportComplete(action: AlertAction)
    case logout(action: AlertAction)
    case resign(action: AlertAction)
    case reportUnknownedError(error: Error, action: AlertAction?)
    case reportGentiError(error: GentiError, action: AlertAction?)
    
    var data: Alert {
        switch self {
        case .report(let action, let placeholder, let text):
            return .init(title: "어떤 오류사항이 있었나요?",
                         message: "구체적으로 작성해주실수록 오류 확인이\n빠르게 진행됩니다!",
                         actions: [.init(title: "취소", style: .cancel),.init(title: "제출하기", action: action)],
                         textFieldPlaceholder: placeholder,
                         textFieldText: text)
        case .reportComplete(let action):
            return .init(title: "의견 감사합니다!",
                         message: "작성해주신 내용 잘 확인하여 더 좋은\n서비스를 제공하는 젠티가 되겠습니다",
                         actions: [.init(title: "확인했습니다", action: action)])
        case .logout(let action):
            return .init(title: "정말 로그아웃 하시겠어요?",
                         message: "사진 생성중에 로그아웃 하시면\n오류가 발생할 수 있습니다. 주의해주세요!",
                         actions: [.init(title: "취소하기", style: .cancel), .init(title: "로그아웃", action: action)])
        case .resign(let action):
            return .init(title: "정말 탈퇴 하시겠어요?",
                         message: "생성한 사진 내역이 모두 사라집니다.\n주의해주세요!",
                         actions: [.init(title: "취소하기", style: .cancel), .init(title: "탈퇴하기", action: action)])
        case .reportUnknownedError(let error, let action):
            return .init(title: "알수없는문제", message: error.localizedDescription, actions: [.init(title: "확인", action: action)])
        case .reportGentiError(let error, let action):
            guard let title = error.code, let message = error.message else {
                return .init(title: "비어있음", message: "비어있음", actions: [.init(title: "확인", action: action)])
            }
            return .init(title: title, message: message, actions: [.init(title: "확인", action: action)])
        }
    }
}
