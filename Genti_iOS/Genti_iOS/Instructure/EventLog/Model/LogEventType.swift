//
//  LogEventType.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

enum LogEventType {
    case singIn(type: GentiSocialLoginType)
    case clickButton(pageName: String, buttonName: String)
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
    
    var eventName: String {
        switch self {
        case .singIn:
            return "sign_in"
        case .clickButton(let pageName, let buttonName):
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
        }
    }
    
    var property: [String: String]? {
        switch self {
        case .singIn(let type):
            return ["signup_method": type.rawValue]
        case .clickButton(let pageName, let buttonName):
            return ["page_name": pageName, "button_name": buttonName]
        default:
            return nil
        }
    }
}
