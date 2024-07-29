//
//  LoginView.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI
import AuthenticationServices

import Alamofire
import KakaoSDKAuth
import KakaoSDKUser

enum LoginUserState {
    case complete
    case notComplete
}

struct SocialLoginEntity {
    var accessToken: String = "어세스토큰"
    var refreshToken: String = "리프래시토큰"
    var userStatus: LoginUserState = .complete
}

protocol LoginUseCase {
    func loginWithKaKao() async throws -> SocialLoginEntity
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> SocialLoginEntity
}

protocol TokenRepository {
    func getAppleToken(_ result: Result<ASAuthorization, any Error>) throws -> String
    func getKaKaoToken() async throws -> String
}

final class TokenRepositoryImpl: TokenRepository {

    func getAppleToken(_ result: Result<ASAuthorization, any Error>) throws -> String {
        switch result {
        case .success(let authResults):
            return try handleAppleSuccess(authResults)
        case .failure(let error):
            return try handleAppleFailure(error)
        }
    }
    
    func getKaKaoToken() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await loginKakaoWithApp()
        }
        return try await loginKakaoWithWeb()
    }
    
    @MainActor
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오로그인실패\(String(describing: error?.localizedDescription))"))
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오토큰을 전달받지 못했습니다"))
                    return
                }
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
    @MainActor
    private func loginKakaoWithWeb() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                guard error == nil else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오로그인실패\(String(describing: error?.localizedDescription))"))
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: GentiError.tokenError(code: "Kakao Token", message: "카카오토큰을 전달받지 못했습니다"))
                    return
                }
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
    private func handleAppleSuccess(_ authResults: ASAuthorization) throws -> String {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            return try getIdentityToken(from: appleIDCredential)
        default:
            throw GentiError.tokenError(code: "Apple Token", message: "Apple login 인증 실패")
        }
    }

    private func getIdentityToken(from appleIDCredential: ASAuthorizationAppleIDCredential) throws -> String {
        if let identityTokenData = appleIDCredential.identityToken,
           let identityToken = String(data: identityTokenData, encoding: .utf8) {
            return identityToken
        } else {
            throw GentiError.tokenError(code: "Apple Token", message: "identityToken을 찾을 수 없습니다")
        }
    }

    private func handleAppleFailure(_ error: Error) throws -> String {
        throw GentiError.tokenError(code: "Apple Token", message: "애플 로그인 실패 \(error.localizedDescription)")
    }    
}

enum GentiSocialLoginType {
    case kakao, apple
}

protocol LoginRepository {
    func login(token: String, type: GentiSocialLoginType) async throws -> SocialLoginEntity
}

final class LoginRepositoryImpl: LoginRepository {
    
    let requestService: RequestService
    
    init(requestService: RequestService) {
        self.requestService = requestService
    }
    
    func login(token: String, type: GentiSocialLoginType) async throws -> SocialLoginEntity {
        // MARK: - 실제 API호출
        return SocialLoginEntity()
    }
}

final class LoginUserCaseImpl: LoginUseCase {
    func loginWithKaKao() async throws -> SocialLoginEntity {
        let token = try await tokenRepository.getKaKaoToken()
        return try await loginRepository.login(token: token, type: .kakao)
    }
    
    func loginWithApple(_ result: Result<ASAuthorization, any Error>) async throws -> SocialLoginEntity {
        let token = try tokenRepository.getAppleToken(result)
        return try await loginRepository.login(token: token, type: .apple)
    }
    
    
    let tokenRepository: TokenRepository
    let loginRepository: LoginRepository
    
    init(tokenRepository: TokenRepository, loginRepository: LoginRepository) {
        self.tokenRepository = tokenRepository
        self.loginRepository = loginRepository
    }
}

struct LoginView: View {
    @State var viewModel: LoginViewModel

    let request = RequestServiceImpl()
    var body: some View {
        GeometryReader(content: {
            geometry in
            VStack(spacing: 55) {
                mainHeaderView()
                socialLoginButtonsView()
            } //:VSTACK
            .position(
                x: geometry.size.width*0.5,
                y: geometry.size.height*0.58
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        })
        .background {
            backgroundView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func socialLoginButtonsView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            kakaoLoginButton()
            appleLoginButton()
        } //:VSTACK
    }
    private func kakaoLoginButton() -> some View {
        Image("Kakao_Login")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 45)
            .asButton {
                viewModel.sendAction(.kakaoLoginTap)
            }
    }
    private func appleLoginButton() -> some View {
        Image("Apple_Login")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 44)
            .overlay {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    viewModel.sendAction(.appleLoginTap(result))
                }
                .blendMode(.overlay)
            }
    }
    private func backgroundView() -> some View {
        Image("Login_Asset")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    private func mainHeaderView() -> some View {
        VStack(spacing: 30) {
            Image("Genti_LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 94)
            
            Text("내 마음대로 표현하는\n하나뿐인 AI사진")
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 20))
            
        } //:VSTACK
    }
}

//#Preview {
//    LoginView(router: .init())
//}
