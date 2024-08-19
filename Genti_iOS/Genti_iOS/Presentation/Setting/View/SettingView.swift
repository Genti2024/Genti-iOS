//
//  SettingView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI
import Combine

import AuthenticationServices

struct SettingView: View {

    @State var viewModel: SettingViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView()
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
        .customAlert(alertType: $viewModel.state.showAlert)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
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
                self.viewModel.sendAction(.termsOfUseRowTap)
            }
            
            SettingRow(title: "개인정보처리방침") {
                self.viewModel.sendAction(.privacyPolicyRowTap)
            }
                
            SettingRow(title: "사업자 정보") {
                self.viewModel.sendAction(.businessInformationRowTap)
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
