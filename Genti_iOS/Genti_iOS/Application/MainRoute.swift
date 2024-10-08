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
    case photoDetailWithShare(imageUrl: String)
    case firstGen
    case secondGen(data: RequestImageData)
    case thirdGen(data: RequestImageData)
    case requestCompleted
    case waiting
    case imagePicker(limitCount: Int, viewModel: GetImageFromImagePicker)
    case webView(url: String)
    case photoDetail(imageUrl: String)
    case completeMakePhoto(photoInfo: CompletedPhotoEntity)
    case recommendOpenChat(openChatInfo: OpenChatEntity)
    case userVerification

    
    @ViewBuilder
    func view(from router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginView(viewModel: LoginViewModel(loginUseCase: LoginUserCaseImpl(tokenRepository: TokenRepositoryImpl(), loginRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .mainTab:
            GentiTabView(viewModel: TabViewModel(tabViewUseCase: TabViewUseCaseImpl(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .setting:
            SettingView(viewModel: SettingViewModel(router: router))
        case .photoDetailWithShare(let imageUrl):
            PhotoDetailWithShareView(viewModel: PhotoDetailViewModel(photoDetailUseCase: PhotoDetailUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl()), router: router, imageUrl: imageUrl))
        case .firstGen:
            RoutingView(router) { FirstGeneratorView(viewModel: FirstGeneratorViewModel(router: $0)) }
        case .secondGen(let data):
            SecondGeneratorView(viewModel: SecondGeneratorViewModel(requestImageData: data, router: router, userdefaultRepository: UserDefaultsRepositoryImpl()))
        case .thirdGen(let data):
            ThirdGeneratorView(viewModel: ThirdGeneratorViewModel(imageGenerateUseCase: ImageGenerateUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl())), requestImageData: data, router: router))
        case .imagePicker(limitCount: let limitCount, viewModel: let viewModel):
            ImagePickerView(viewModel: ImagePickerViewModel(router: router, limit: limitCount, generatorViewModel: viewModel, photoUseCase: PhotoUseCaseImpl(albumRepository: AlbumRepositoryImpl())))
        case .requestCompleted, .waiting:
            GenerateRequestCompleteView(router: router)
        case .webView(url: let url):
            GentiWebView(router: router, urlString: url)
        case .photoDetail(let imageUrl):
            PhotoDetailView(viewModel: PhotoDetailViewModel(photoDetailUseCase: PhotoDetailUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl()), router: router, imageUrl: imageUrl))
        case .completeMakePhoto(let photoInfo):
            RoutingView(router) { CompletedPhotoView(viewModel: CompletedPhotoViewModel(photoInfo: photoInfo, router: $0, completedPhotoUseCase: CompletedPhotoUseCaseImpl(imageRepository: ImageRepositoryImpl(), hapticRepository: HapticRepositoryImpl(), userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())))) }
        case .onboarding:
            OnboardingView(viewModel: OnboardingViewModel(router: router))
        case .signIn:
            SignInView(viewModel: SignInViewModel(signInUseCase: SignInUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: router))
        case .recommendOpenChat(let openChatInfo):
            OpenChatInfoView(router: router, openChatUrl: openChatInfo.openChatUrl, numberOfPeople: openChatInfo.numberOfPeople)
        case .userVerification:
            FaceCertificationView(viewModel: FaceCertificationViewModel(router: router, verificationUseCase: VerificationUseCaseImpl(generateRepository: ImageGenerateRepositoryImpl(requsetService: RequestServiceImpl(), imageDataTransferService: ImageDataTransferServiceImpl(), uploadService: UploadServiceImpl()))))
        }
    }
        
    var navigationType: NavigationType {
        switch self {
        case .login, .mainTab, .setting, .secondGen, .thirdGen, .requestCompleted, .webView, .signIn:
            return .push
        case .photoDetailWithShare, .firstGen, .imagePicker, .photoDetail, .completeMakePhoto, .onboarding, .waiting, .recommendOpenChat, .userVerification:
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

