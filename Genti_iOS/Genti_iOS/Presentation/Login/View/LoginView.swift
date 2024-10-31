//
//  LoginView.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State var viewModel: LoginViewModel
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                backgroundView()
                Spacer()
            }
            
            VStack {
                mainHeaderView()
                Spacer()
                socialLoginButtonsView()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    private func socialLoginButtonsView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            kakaoLoginButton()
            appleLoginButton()
        } //:VSTACK
    }
    private func kakaoLoginButton() -> some View {
        Image(.kakaoLoginNew)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 48)
            .asButton {
                viewModel.sendAction(.kakaoLoginTap)
            }
    }
    private func appleLoginButton() -> some View {
        Image(.appleLoginNew)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 48)
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
        Image(.imgBack)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    private func mainHeaderView() -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("내 마음대로 세상에 하나뿐인\n나의 AI 사진을 찍어 보세요.")
                .multilineTextAlignment(.leading)
                .pretendard(.title1_24_bold)
                .foregroundStyle(.white)
            
            Text("5초만에 가입해서 바로 시작할 수 있어요.")
                .pretendard(.body_14_medium)
                .foregroundStyle(.white)
            
        } //:VSTACK
        .padding(.top, 76)
    }
}

//#Preview {
//    LoginView(router: .init())
//}
