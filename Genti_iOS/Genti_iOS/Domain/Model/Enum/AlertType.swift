//
//  AlertType.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

enum AlertType {
    
    typealias AlertAction = (()->Void)
    
    case report(action: AlertAction?, cancelAction: AlertAction?, placeholder: String, text: Binding<String>)
    case reportComplete(action: AlertAction?)
    case logout(action: AlertAction?)
    case resign(action: AlertAction?)
    case reportError(action: AlertAction?)
    case reportUnknownedError(error: Error, action: AlertAction?)
    case reportGentiError(error: GentiError, action: AlertAction?)
    case albumAuthorization
    case photoCompleted(action: AlertAction?)
    case photoRequestCanceled(action: AlertAction?)
    case pushAuthorization(action: AlertAction?)
    case update(action: AlertAction?)
    case InspectionTime(title: String?)
    
    var data: Alert {
        switch self {
        case .report(let action, let cancelAction,  let placeholder, let text):
            return .init(title: "어떤 오류사항이 있었나요?",
                         message: "구체적으로 작성해주실수록 오류 확인이\n빠르게 진행됩니다!",
                         actions: [.init(title: "취소", style: .cancel, action: cancelAction),.init(title: "제출하기", action: action)],
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
            return .init(title: "알수없는문제",
                         message: error.localizedDescription,
                         actions: [.init(title: "확인", action: action)])
        case .reportGentiError(let error, let action):
            guard let title = error.code, let message = error.message else {
                return .init(title: "오류발생",
                             message: "잠시후 다시 실행해주세요",
                             actions: [.init(title: "확인", action: action)])
            }
            return .init(title: title,
                         message: message,
                         actions: [.init(title: "확인", action: action)])
        case .albumAuthorization:
            return .init(title: "앨범접근이 필요해요",
                         message: "나만의 사진을 만들기위해서는 앨법접근권한이 필요해요",
                         actions: [.init(title: "설정으로가기", action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil) }), .init(title: "괜찮아요", style: .cancel)])
        case .photoCompleted(let action):
            return .init(title: "사진이 완성되었어요!",
                         message: "다른 사진을 만들기 전에\n완성된 사진을 확인할까요?",
                         actions: [.init(title: "사진 확인하기", action: action)])
        case .photoRequestCanceled(let action):
            return .init(title: "정말 죄송합니다",
                         message: "서버에 오류가 발생해서\n사진이 만들어지지 않았어요",
                         actions: [.init(title: "사진 다시 생성하기", action: action)])
        case .pushAuthorization(let action):
            return .init(title: "알림접근이 필요해요",
                         message: "나만의 사진을 만들기위해서는 알림권한이 필요해요",
                         actions: [.init(title: "설정으로가기", action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { _ in
                action!()
            } }), .init(title: "괜찮아요", style: .cancel, action: action)])
        case .reportError(action: let action):
            return .init(title: "일시적인 오류 발생", message: "앱을 종료 후 다시 시도해주세요\n로그인화면으로 이동합니다", actions: [.init(title: "확인", action: action)])
        case .update(action: let action):
            return .init(title: "업데이트 알림", message: "더 나은 서비스를 위해 필요한 업데이트가 있습니다!\n업데이트해주시겠어요?", actions: [.init(title: "업데이트하러 가기", action: action)])
        case .InspectionTime(let title):
            return .init(title: "서비스 점검 중", message: "더 나은 서비스를 위해 점검중입니다\n\(title ?? "하루 후에 이용해주세요")", actions: [.init(title: "확인", action: nil)])
        }
    }
}
