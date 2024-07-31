//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import SDWebImageSwiftUI
import Lottie

@Observable
final class SplashViewModel: ViewModel {
    var state: State
    
    var router: Router<MainRoute>
    var authRepository: AuthRepository
    var userdefaultRepository: UserDefaultsRepository
    
    init(router: Router<MainRoute>, authRepository: AuthRepository, userdefaultRepository: UserDefaultsRepository) {
        self.router = router
        self.authRepository = authRepository
        self.userdefaultRepository = userdefaultRepository
        self.state = .init()
    }

    struct State {}
    
    enum Input {
        case splashAnimationFinished
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .splashAnimationFinished:
            guard let userRole = userdefaultRepository.getUserRole() else {
                print(#fileID, #function, #line, "- userrole이 없음")
                router.routeTo(.login)
                return
            }
            
            switch userRole {
            case .complete:
                print(#fileID, #function, #line, "- userrole이 회원가입까지 완료된 상태")
                Task {
                    do {
                        let token = userdefaultRepository.getToken()
                        guard let accessToken = token.accessToken, let refreshToken = token.refreshToken else {
                            print(#fileID, #function, #line, "- userrole은 있는데 token은 nil임")
                            router.routeTo(.login)
                            return
                        }
                        let reissuedToken = try await authRepository.reissueToken(token: .init(accessToken: accessToken, refreshToken: refreshToken))
                        userdefaultRepository.setToken(token: reissuedToken)
                        router.routeTo(.mainTab)
                        return
                    } catch {
                        print(#fileID, #function, #line, "- 스플래시에서 오류발생")
                        router.routeTo(.login)
                    }
                }
            case .notComplete:
                print(#fileID, #function, #line, "- userrole이 회원가입이 완료된 상태가 아님")
                router.routeTo(.login)
            }
            
        }
    }
}

struct SplashView: View {
    @State var splashViewModel: SplashViewModel
    
    var body: some View {
        
        ZStack {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            // Content
            Text("스플래시뷰입니다")
                .foregroundStyle(.black)
                .pretendard(.headline1)
                .onAppear {
                    Task {
                        do {
                            try await Task.sleep(nanoseconds: 1000000000)
                            await MainActor.run {
                                self.splashViewModel.sendAction(.splashAnimationFinished)
                            }
                        }

                    }
                }
        } //:ZSTACK
    }
}
