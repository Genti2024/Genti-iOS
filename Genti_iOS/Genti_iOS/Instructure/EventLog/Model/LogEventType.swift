//
//  LogEventType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

enum LogEventType {
    case error(errorCode: String?, errorMessage: String?)
    case singIn(type: GentiSocialLoginType)
    case clickButton(page: PageType, buttonName: String)
    case viewInfoget
    case completeInfoget
    case scrollMainView
    case refreshMainView
    case clickMainTab
    case clickCreateTab
    case clickMyPageTab
    case clickDisableButtonInSecondGeneratorView
    case addThreeUserPickture
    case enlargePhoto
    case downloadPhoto
    case reportPhoto
    case sendPhotoRating
    case skipPhotoRating
    case logout
    case resign
    case seeCompletePhoto
    case pushNotificationTap(Bool)
    
    var eventName: String {
        switch self {
        case .singIn:
            return "sign_in"
        case .clickButton:
            return "click_button"
        case .viewInfoget:
            return "view_infoget"
        case .scrollMainView:
            return "scroll_main"
        case .refreshMainView:
            return "refresh_main"
        case .clickMainTab:
            return "click_maintab"
        case .clickCreateTab:
            return "click_createpictab"
        case .clickMyPageTab:
            return "click_mypagetab"
        case .clickDisableButtonInSecondGeneratorView:
            return "click_create2_next_gray"
        case .addThreeUserPickture:
            return "add_create3_userpic3"
        case .completeInfoget:
            return "complete_infoget"
        case .enlargePhoto:
            return "enlarge_mypage_picture"
        case .downloadPhoto:
            return "download_picdone_enlargedpicture"
        case .reportPhoto:
            return "reportpic_picdone"
        case .sendPhotoRating:
            return "ratingsubmit_picdone"
        case .skipPhotoRating:
            return "ratingpass_picdone"
        case .logout:
            return "log_out"
        case .resign:
            return "sign_out"
        case .seeCompletePhoto:
            return "view_picdone"
        case .pushNotificationTap:
            return "click_push_notification"
        case .error:
            return "error"
        }
    }
    
    var property: [String: String]? {
        switch self {
        case .singIn(let type):
            return ["signup_method": type.rawValue]
        case .clickButton(let page, let buttonName):
            return ["page_name": page.pageName, "button_name": buttonName]
        case .pushNotificationTap(let success):
            return ["push_type": success ? "creating_success" : "creating_fail"]
        case .error(let errorCode, let errorMessage):
            guard let errorCode = errorCode, let errorMessage = errorMessage else {
                return ["errorCode": "nil입니다", "errorMessage": "nil입니다"]
            }
            return ["errorCode": errorCode, "errorMessage": errorMessage]
        default:
            return nil
        }
    }
}
