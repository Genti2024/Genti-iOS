//
//  LoginView.swift
//  Genti
//
//  Created by uiskim on 4/14/24.
//

import SwiftUI
import Alamofire

struct LoginView: View {
    @Bindable var router: Router<MainRoute>
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
                router.routeTo(.mainTab)
            }
    }
    private func appleLoginButton() -> some View {
        Image("Apple_Login")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 44)
            .asButton {
                self.router.routeTo(.completeMakeImage)
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

#Preview {
    LoginView(router: .init())
}
