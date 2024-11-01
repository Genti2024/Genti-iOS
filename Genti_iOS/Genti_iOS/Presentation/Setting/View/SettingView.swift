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
            Color.geintiBackground
                .ignoresSafeArea()
            VStack(spacing: 4) {
                headerView()
                    
                infoView()
                
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 18)
                
                userView()
                Spacer()
            } //:VSTACK
            if viewModel.state.isLoading {
                LoadingView()
            }
        } //:ZSTACK
        .customAlert(alertType: $viewModel.state.showAlert)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func headerView() -> some View {
        
        Text("설정")
            .pretendard(.subtitle1_18_bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .overlay(alignment: .center) {
                HStack(alignment: .center) {
                    Image(.backNew)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            self.viewModel.sendAction(.backButtonTap)
                        }
                    
                    Spacer()
                }

            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
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
                .pretendard(.subtitle2_16_bold)
                .foregroundStyle(.white)
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    Text(AppStoreCheck.appVersion ?? "1.0.0")
                        .pretendard(.normal)
                        .foregroundStyle(.gray3)
                }
                .padding(.horizontal, 16)
            
        }
    }
    private func userView() -> some View {
        VStack(spacing: 0) {
            Text("로그아웃")
                .pretendard(.subtitle2_16_bold)
                .foregroundStyle(.gentiGreenNew)
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.viewModel.sendAction(.logoutRowTap)
                }
            Text("회원탈퇴")
                .pretendard(.subtitle2_16_bold)
                .foregroundStyle(.white.opacity(0.6))
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.viewModel.sendAction(.resignRowTap)
                }
        }
    }
}


//#Preview {
//    SettingView(router: .init())
//}
