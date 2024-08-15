//
//  SettingView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI
import Combine

import AuthenticationServices

protocol SettingUseCase {
    var appleResignCompleteSubject: PassthroughSubject<Void, Never> { get set }
    var kakaoResignCompleteSubject: PassthroughSubject<Void, Never> { get set }
    func logout() async throws
    func performSignIn()
    func resign() async throws
}

final class SettingUseCaseImpl: NSObject, SettingUseCase, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var appleResignCompleteSubject = PassthroughSubject<Void, Never>()
    var kakaoResignCompleteSubject = PassthroughSubject<Void, Never>()
    
    func resign() async throws {
        guard let loginType = userdefaultRepository.getLoginType() else { throw GentiError.clientError(code: "로그인타입", message: "로그인이 안된 유저입니다")}
        switch loginType {
        case .kakao:
            try await authRepository.resignKakao()
            userdefaultRepository.removeToken()
            userdefaultRepository.removeUserRole()
            EventLogManager.shared.logEvent(.resign)
            kakaoResignCompleteSubject.send(())
        case .apple:
            performSignIn()
        }
    }
    
    
    let tokenRepository = TokenRepositoryImpl()
    let authRepository = AuthRepositoryImpl(requestService: RequestServiceImpl())
    let userdefaultRepository = UserDefaultsRepositoryImpl()
    
    func logout() async throws {
        try await authRepository.logout()
        userdefaultRepository.removeToken()
        userdefaultRepository.removeUserRole()
        EventLogManager.shared.logEvent(.logout)
    }
    
    
    func performSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // ASAuthorizationControllerDelegate 메서드
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Apple ID 인증이 성공적으로 완료되었을 때의 처리
            Task {
                do {
                    let authToken = try tokenRepository.getAppleAuthToken(appleIDCredential)
                    try await authRepository.resignApple(authToken: authToken)
                    userdefaultRepository.removeToken()
                    userdefaultRepository.removeUserRole()
                    EventLogManager.shared.logEvent(.resign)
                    self.appleResignCompleteSubject.send(())
                } catch {
                    
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error during sign-in: \(error.localizedDescription)")
    }
    
    // ASAuthorizationControllerPresentationContextProviding 메서드
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}

@Observable
final class SettingViewModel: NSObject, ViewModel {
    var cancelBag = Set<AnyCancellable>()
    var router: Router<MainRoute>
    let requestService: RequestService = RequestServiceImpl()
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    let settingUseCase: SettingUseCase = SettingUseCaseImpl()
    var state: State
    
    struct State {
        var authorizationCode: String? = nil
        var error: Error? = nil
        var showLogoutAlert: Bool = false
        var showResignAlert: Bool = false
        var isLoading: Bool = false
    }
    
    enum Input {
        case resign
        case logoutAlertComformButtomTap
        case backButtonTap
        case logoutRowTap
        case resignRowTap
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .resign:
            Task { await resign() }
        case .logoutAlertComformButtomTap:
            Task { await logout() }
        case .backButtonTap:
            router.dismiss()
        case .logoutRowTap:
            self.state.showLogoutAlert = true
        case .resignRowTap:
            self.state.showResignAlert = true
        }
    }
    
    init(router: Router<MainRoute>) {
        self.router = router
        self.state = .init()
        super.init()
        
        self.settingUseCase.kakaoResignCompleteSubject.merge(with: self.settingUseCase.appleResignCompleteSubject
            .delay(for: .seconds(0.5), scheduler: RunLoop.main))
            .sink { _ in router.popToRoot() }
            .store(in: &self.cancelBag)

    }
    
    @MainActor
    func resign() async {
        do {
            self.state.isLoading = true
            try await settingUseCase.resign()
            self.state.isLoading = false
        } catch(let error) {
            self.state.isLoading = false
            print(error)
        }
    }
    
    @MainActor
    func logout() async {
        do {
            self.state.isLoading = true
            try await settingUseCase.logout()
            router.popToRoot()
        } catch(let error) {
            self.state.isLoading = false
            print(error)
        }
    }
}

struct SettingView: View {

    @State var viewModel: SettingViewModel

    
    let requestService: RequestService = RequestServiceImpl()
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background Color
            backgroundView()
            // Content
            VStack(spacing: 4) {
                headerView()
                infoView()
                userView()
                Spacer()
                footerView()
            } //:VSTACK
            if viewModel.state.isLoading {
                LoadingView()
            }
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .alert("정말 로그아웃 하시겠어요?", isPresented: $viewModel.state.showLogoutAlert) {
            Button("로그아웃") {
                self.viewModel.sendAction(.logoutAlertComformButtomTap)
            }
            Button("취소하기", role: .cancel, action: {})
        } message: {
            Text("사진 생성 중에 로그아웃 하시면\n오류가 발생할 수 있습니다. 주의해주세요!")
        }
        
        .alert("정말 탈퇴 하시겠어요?", isPresented: $viewModel.state.showResignAlert) {
            Button("탈퇴하기") {
                self.viewModel.sendAction(.resign)
//                Task { await resign() }
            }
            Button("취소하기", role: .cancel, action: {})
        } message: {
            Text("생성한 사진 내역이 모두 사라집니다.\n주의해주세요!")
        }

    }
    

    private func backgroundView() -> some View {
        ZStack(alignment: .top) {
            Color.backgroundWhite
                .ignoresSafeArea()
            
            Color.green3
                .frame(height: 100)
                .ignoresSafeArea()
        }
    }
    private func headerView() -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.green3)
            .frame(height: 100)
            .overlay(alignment: .bottomLeading) {
                Text("설정 및 개인정보")
                    .pretendard(.normal)
                    .foregroundStyle(.gray3)
                    .padding(.bottom, 17)
                    .padding(.leading, 40)
            }
            .overlay(alignment: .topLeading) {
                Image("Back_fill")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .padding(.leading, 30)
                    .padding(.top, 16)
                    .onTapGesture {
                        self.viewModel.sendAction(.backButtonTap)
                    }
            }
    }
    private func infoView() -> some View {
        VStack(spacing: 0) {
            SettingRow(title: "이용 약관") {
                self.viewModel.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/5e84488cbf874b8f91e779ea4dc8f08a"))
            }
            SettingRow(title: "개인정보처리방침") {
                self.viewModel.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/e0f2e17a3a60437b8e62423f61cca2a9"))
            }
                
            SettingRow(title: "사업자 정보") {
                self.viewModel.router.routeTo(.webView(url: "https://stealth-goose-156.notion.site/39d39ae82a3a436fa053e5287ff9742c"))
            }
            
            Text("앱 버전 정보")
                .pretendard(.normal)
                .foregroundStyle(.black)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    Text("1.0.0")
                        .pretendard(.normal)
                        .foregroundStyle(.gray3)
                }
                .padding(.leading, 20)
            
        }
        .padding(20)
        .background(.gray6)
        .clipShape(.rect(cornerRadius: 15))
    }
    private func userView() -> some View {
        VStack(spacing: 0) {
            SettingRow(title: "로그아웃") {
                self.viewModel.sendAction(.logoutRowTap)
            }
            
            Text("회원탈퇴")
                .pretendard(.normal)
                .foregroundStyle(.gray3)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .background(.gray6)
                .onTapGesture {
                    self.viewModel.sendAction(.resignRowTap)
                }
        }
        .padding(20)
        .background(.gray6)
        .clipShape(.rect(cornerRadius: 15))
    }
    private func footerView() -> some View {
        Image("Genti_LOGO")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 38)
            .padding(.bottom, 10)
    }
}


//#Preview {
//    SettingView(router: .init())
//}
