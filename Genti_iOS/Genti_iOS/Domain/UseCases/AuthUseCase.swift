////
////  AuthUseCase.swift
////  Genti_iOS
////
////  Created by uiskim on 9/5/24.
////
//
//import Foundation
//import AuthenticationServices
//import Photos
//
//protocol AuthUseCase {
//    func autoLogin() async -> Bool
//    func loginWithKaKao() async throws -> LoginUserState
//    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState
//    func signIn(gender: Gender?, birthYear: Int) async throws
//    func logout() async throws
//    func resign() async throws
//}
//
//struct AuthUseCaseImpl: AuthUseCase {
//    let authRepository: AuthRepository
//    let userdefaultRepository: UserDefaultsRepository
//    
//    func autoLogin() async -> Bool {
//        guard checkUserAlreadySignIn() else { return false }
//        if await authRepository.reissueTokenSuccess() {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    private func checkUserAlreadySignIn() -> Bool {
//        return userdefaultRepository.getUserRole() == .signInComplete
//    }
//    
//    func loginWithKaKao() async throws -> LoginUserState {
//        <#code#>
//    }
//    
//    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> LoginUserState {
//        <#code#>
//    }
//    
//    func signIn(gender: Gender?, birthYear: Int) async throws {
//        <#code#>
//    }
//    
//    func logout() async throws {
//        <#code#>
//    }
//    
//    func resign() async throws {
//        <#code#>
//    }
//    
//    
//}
//
//protocol ExampleUseCase {
//    func getExamples() async throws -> [FeedEntity]
//}
//
//protocol UserUseCase {
//    func fetchUserProfile() async throws -> UserInfoEntity // 프로필상태조회니까 네이밍변경해야할듯
//    func getUserState() async throws -> UserState
//    func checkCanceledImage(requestId: Int) async throws
//    func showCompleteStateWhenUserInitalAccess() async throws -> Bool
//}
//
//protocol AlbumUseCase {
//    func getAlbums() -> [Album]
//    func getPhotos(at album: Album) -> [PHAsset]
//}
//
//protocol ImageUseCase {
//    func requestImage(from userData: RequestImageData) async throws
//    func load(from urlString: String) async -> UIImage?
//    func downloadImage(to uiImage: UIImage?) async -> Bool
//    func reportImage(responseId: Int, content: String) async throws
//    func rateImage(responseId: Int, rate: Int) async throws
//}
