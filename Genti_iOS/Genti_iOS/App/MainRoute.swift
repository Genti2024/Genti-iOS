//
//  MainRoute.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

enum MainRoute: Route {
    
    case login
    case mainTab
    case setting
    case photoDetailWithShare(imageUrl: String)
    case firstGen
    case secondGen(data: RequestImageData)
    case thirdGen(data: RequestImageData)
    case requestCompleted
    case imagePicker(limitCount: Int, viewModel: GetImageFromImagePicker)
    case webView(url: String)
    case photoDetail(url: String)
    case completeMakeImage
    
    @ViewBuilder
    func view(from router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(router: router)
        case .mainTab:
            GentiTabView(router: router)
        case .setting:
            SettingView(router: router)
        case .photoDetailWithShare(let url):
            PhotoDetailWithShareView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, imageUrlString: url))
        case .firstGen:
            RoutingView(router) { FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: $0)) }
        case .secondGen(let data):
            SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: data, router: router))
        case .thirdGen(let data):
            ThirdGeneratorView(viewModel: ThirdGeneratorViewModel(imageGenerateUseCase: ImageGenerateUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl())), requestImageData: data, router: router))
        case .imagePicker(limitCount: let limitCount, viewModel: let viewModel):
            PopupImagePickerView(viewModel: ImagePickerViewModel(generatorViewModel: viewModel, router: router, limit: limitCount, albumUseCase: AlbumUseCaseImpl(albumRepository: AlbumRepositoryImpl(albumService: AlbumServiceImpl()))))
        case .requestCompleted:
            GenerateRequestCompleteView(router: router)
        case .webView(url: let url):
            GentiWebView(router: router, urlString: url)
        case .photoDetail(let url):
            PhotoDetailView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, imageUrlString: url))
        case .completeMakeImage:
            RoutingView(router) { PhotoCompleteView(viewModel: PhotoCompleteViewViewModel(photoInfo: .init(), router: $0, imageRepository: ImageRepositoryImpl())) }
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView:
            return .push
        case .photoDetailWithShare, .firstGen, .imagePicker, .photoDetail, .completeMakeImage:
            return .fullScreenCover
        }
    }
    
    static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        switch (lhs, rhs) {
        case (.photoDetailWithShare(let lhsUrl), .photoDetailWithShare(let rhsUrl)), (.webView(let lhsUrl), .webView(let rhsUrl)):
            return lhsUrl == rhsUrl
        case (.imagePicker, .imagePicker):
            return false
        default:
            return true
        }
    }
}

