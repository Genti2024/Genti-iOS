//
//  SettingView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct SettingRow: View {
    
    var title: String
    var rowTapped: (()->Void)? = nil
    
    var body: some View {
        Text(title)
            .pretendard(.normal)
            .foregroundStyle(.black)
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
    }
}

struct SettingView: View {
    
    @Binding var tabbarHidden: Bool
    @Binding var settingFlow: [SettingFlow]
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background Color
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
                        
                    }
                    SettingRow(title: "개인정보처리방침") {
                        
                    }
                    SettingRow(title: "앱 버전 정보") {
                        
                    }
                    SettingRow(title: "사업자 정보") {
                        
                    }
                }
                .padding(20)
                .background(.gray6)
                .clipShape(.rect(cornerRadius: 15))
                
                VStack(spacing: 0) {
                    SettingRow(title: "로그아웃") {
                        
                    }
                    SettingRow(title: "회원탈퇴") {
                        
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
    }
}

#Preview {
    SettingView(tabbarHidden: .constant(true), settingFlow: .constant([]))
}
