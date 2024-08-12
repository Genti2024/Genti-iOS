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
    case onboarding
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
    case completeMakePhoto(photoInfo: CompletedPhotoEntity)

    
    @ViewBuilder
    func view(from router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(viewModel: LoginViewModel(loginUseCase: LoginUserCaseImpl(tokenRepository: TokenRepositoryImpl(), loginRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .mainTab:
            GentiTabView(viewModel: TabViewModel(tabViewUseCase: TabViewUseCaseImpl(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .setting:
            SettingView(router: router)
        case .photoDetailWithShare(let image):
            PhotoDetailWithShareView(viewModel: PhotoDetailViewModel(photoDetailUseCase: PhotoDetailUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl()), router: router, image: image))
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
            PhotoDetailView(viewModel: PhotoDetailViewModel(photoDetailUseCase: PhotoDetailUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl()), router: router, image: image))
        case .completeMakePhoto(let photoInfo):
            RoutingView(router) { CompletedPhotoView(viewModel: CompletedPhotoViewViewModel(photoInfo: photoInfo, router: $0, completedPhotoUseCase: CompletedPhotoUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())))) }
        case .onboarding:
            OnboardingView(viewModel: OnboardingViewModel(router: router))
        case .signIn:
            SignInView(viewModel: SignInViewModel(signInUseCase: SignInUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView, .signIn:
            return .push
        case .photoDetailWithShare, .firstGen, .imagePicker, .photoDetail, .completeMakePhoto, .onboarding, .waiting:
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

