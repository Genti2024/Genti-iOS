//
//  MainRoute.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

enum MainRoute: Routable {
    
    case login
    case mainTab
    case setting
    case expandImage(imageUrl: String)
    case firstGen
    case secondGen
    case thirdGen
    case requestCompleted
    case imagePicker(limitCount: Int, viewModel: GeneratorViewModel)
    case webView(url: String)
    
    @ViewBuilder
    func viewToDisplay(router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(router: router)
        case .mainTab:
            GentiTabView(router: router)
        case .setting:
            SettingView(router: router)
        case .expandImage(let url):
            PostDetailView(router: router, imageUrl: url)
        case .firstGen:
            RoutingView(router) { FirstGeneratorView(router: $0) }
        case .secondGen:
            SecondGeneratorView(router: router)
        case .thirdGen:
            ThirdGeneratorView(router: router)
        case .imagePicker(limitCount: let limitCount, viewModel: let viewModel):
            PopupImagePickerView(limitCount: limitCount, viewModel: viewModel)
        case .requestCompleted:
            GenerateRequestCompleteView(router: router)
        case .webView(url: let url):
            GentiWebView(router: router, urlString: url)
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView:
            return .push
        case .expandImage, .firstGen, .imagePicker:
            return .fullScreenCover
        }
    }
    
    static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        switch (lhs, rhs) {
        case (.expandImage(let lhsUrl), .expandImage(let rhsUrl)), (.webView(let lhsUrl), .webView(let rhsUrl)):
            return lhsUrl == rhsUrl
        case (.imagePicker, .imagePicker):
            return false
        default:
            return true
        }
    }
}
