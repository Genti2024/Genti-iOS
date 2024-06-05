//
//  SettingView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct SettingView: View {
    
    @Binding var tabbarHidden: Bool
    @Binding var settingFlow: [SettingFlow]
    
    @State private var showLogoutAlert: Bool = false
    @State private var showResignAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background Color
            Color.backgroundWhite
                .ignoresSafeArea()
            
            Color.green3
                .frame(height: 100)
                .ignoresSafeArea()
            // Content
            VStack(spacing: 4) {
                
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
                            .onTapGesture {
                                self.tabbarHidden = false
                                self.settingFlow.removeLast()
                            }
                    }
                
                VStack(spacing: 0) {
                    SettingRow(title: "이용 약관") {
                        self.settingFlow.append(.notion(urlString: "https://stealth-goose-156.notion.site/5e84488cbf874b8f91e779ea4dc8f08a"))
                    }
                    SettingRow(title: "개인정보처리방침") {
                        self.settingFlow.append(.notion(urlString: "https://stealth-goose-156.notion.site/e0f2e17a3a60437b8e62423f61cca2a9"))
                        
                    }
                    SettingRow(title: "앱 버전 정보") {
                        self.settingFlow.append(.notion(urlString: "https://stealth-goose-156.notion.site/iOS-4f75393b25e84ceeb2cff037a671146d"))
                    }
                    SettingRow(title: "사업자 정보") {
                        self.settingFlow.append(.notion(urlString: "https://stealth-goose-156.notion.site/39d39ae82a3a436fa053e5287ff9742c"))
                    }
                }
                .padding(20)
                .background(.gray6)
                .clipShape(.rect(cornerRadius: 15))
                
                VStack(spacing: 0) {
                    SettingRow(title: "로그아웃") {
                        self.showLogoutAlert = true
//                        NavigationUtil.popToRootView()
                    }
                    SettingRow(title: "회원탈퇴") {
                        NavigationUtil.popToRootView()
                    }
                }
                .padding(20)
                .background(.gray6)
                .clipShape(.rect(cornerRadius: 15))
                
                Spacer()
                
                Image("Genti_LOGO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 38)
                    .padding(.bottom, 10)
            } //:VSTACK
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            self.tabbarHidden = true
        }
        .alert("정말 로그아웃 하시겠어요?", isPresented: $showLogoutAlert) {
            Button("로그아웃") {
                Task {
                    do {
                        try await Task.sleep(nanoseconds: 1000000000)
                        print("sfsf")
                    } catch {
                        
                    }
                }

            }
            Button("취소하기", role: .cancel, action: {})
        } message: {
            Text("사진 생성 중에 로그아웃 하시면\n오류가 발생할 수 있습니다. 주의해주세요!")
        }

    }
}

#Preview {
    SettingView(tabbarHidden: .constant(true), settingFlow: .constant([]))
}
