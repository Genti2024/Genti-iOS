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
    case photoDetailWithShare(image: UIImage)
    case firstGen
    case secondGen(data: RequestImageData)
    case thirdGen(data: RequestImageData)
    case requestCompleted
    case imagePicker(limitCount: Int, viewModel: GetImageFromImagePicker)
    case webView(url: String)
    case photoDetail(image: UIImage)
    case completeMakeImage
    case onboarding
    
    @ViewBuilder
    func view(from router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(router: router)
        case .mainTab:
            GentiTabView(router: router)
        case .setting:
            SettingView(router: router)
        case .photoDetailWithShare(let image):
            PhotoDetailWithShareView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, image: image))
        case .firstGen:
            RoutingView(router) { FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: $0)) }
        case .secondGen(let data):
            SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: data, router: router))
        case .thirdGen(let data):
            ThirdGeneratorView(viewModel: ThirdGeneratorViewModel(imageGenerateUseCase: ImageGenerateUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl())), requestImageData: data, router: router))
        case .imagePicker(limitCount: let limitCount, viewModel: let viewModel):
            PopupImagePickerView(viewModel: ImagePickerViewModel(generatorViewModel: viewModel, router: router, limit: limitCount, albumRepository: AlbumRepositoryImpl(albumService: AlbumServiceImpl())))
        case .requestCompleted:
            GenerateRequestCompleteView(router: router)
        case .webView(url: let url):
            GentiWebView(router: router, urlString: url)
        case .photoDetail(let image):
            PhotoDetailView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, image: image))
        case .completeMakeImage:
            RoutingView(router) { PhotoCompleteView(viewModel: PhotoCompleteViewViewModel(photoInfo: .init(), router: $0, imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()))) }
        case .onboarding:
            OnboardingView(viewModel: OnboardingViewModel(router: router))
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView:
            return .push
        case .photoDetailWithShare, .firstGen, .imagePicker, .photoDetail, .completeMakeImage, .onboarding:
            return .fullScreenCover
        }
    }
    
    static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        switch (lhs, rhs) {
        case (.webView(let lhsUrl), .webView(let rhsUrl)):
            return lhsUrl == rhsUrl
        case (.imagePicker, .imagePicker):
            return false
        default:
            return true
        }
    }
}

