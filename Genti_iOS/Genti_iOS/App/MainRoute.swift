//
//  MainRoute.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

enum MainRoute: Route {
    
    case login
    case signIn
    case mainTab
    case setting
    case photoDetailWithShare(image: UIImage)
    case firstGen
    case secondGen(data: RequestImageData)
    case thirdGen(data: RequestImageData)
    case requestCompleted
    case waiting
    case imagePicker(limitCount: Int, viewModel: GetImageFromImagePicker)
    case webView(url: String)
    case photoDetail(image: UIImage)
    case completeMakeImage(imageInfo: CompletePhotoEntity)
    case onboarding
    
    @ViewBuilder
    func view(from router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(viewModel: LoginViewModel(loginUseCase: LoginUserCaseImpl(tokenRepository: TokenRepositoryImpl(), loginRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .mainTab:
            GentiTabView(viewModel: TabViewModel(tabViewUseCase: TabViewUseCaseImpl(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())), router: router))
        case .setting:
            SettingView(router: router)
        case .photoDetailWithShare(let image):
            PhotoDetailWithShareView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, image: image))
        case .firstGen:
            RoutingView(router) { FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: $0)) }
        case .secondGen(let data):
            SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: data, router: router, userdefaultRepository: UserDefaultsRepositoryImpl()))
        case .thirdGen(let data):
            ThirdGeneratorView(viewModel: ThirdGeneratorViewModel(imageGenerateUseCase: ImageGenerateUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl())), requestImageData: data, router: router))
        case .imagePicker(limitCount: let limitCount, viewModel: let viewModel):
            PopupImagePickerView(viewModel: ImagePickerViewModel(generatorViewModel: viewModel, router: router, limit: limitCount, albumRepository: AlbumRepositoryImpl(albumService: AlbumServiceImpl())))
        case .requestCompleted, .waiting:
            GenerateRequestCompleteView(router: router)
        case .webView(url: let url):
            GentiWebView(router: router, urlString: url)
        case .photoDetail(let image):
            PhotoDetailView(viewModel: PhotoDetailViewModel(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), router: router, image: image))
        case .completeMakeImage(let imageInfo):
            RoutingView(router) { PhotoCompleteView(viewModel: PhotoCompleteViewViewModel(photoInfo: imageInfo, router: $0, imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()))) }
        case .onboarding:
            OnboardingView(viewModel: OnboardingViewModel(router: router))
        case .signIn:
            CollectUserInfomationView(viewModel: CollectUserInfomationViewModel(router: router, authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl())))
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView, .signIn:
            return .push
        case .photoDetailWithShare, .firstGen, .imagePicker, .photoDetail, .completeMakeImage, .onboarding, .waiting:
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

