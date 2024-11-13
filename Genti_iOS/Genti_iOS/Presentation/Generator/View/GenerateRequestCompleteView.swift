//
//  GenerateCompleteView.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import SwiftUI

import Lottie

struct GenerateRequestCompleteView: View {
    @Bindable var router: Router<MainRoute>
    @State private var showPushAuthorizationPopUp: Bool = false
    @State private var alertType: AlertType? = nil
    var body: some View {
        ZStack {
            
            Color.geintiBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(.glowNew)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            }
            .ignoresSafeArea()


            // Content
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 32)
                VStack(spacing: 10) {
                    Text("사진 생성 중")
                        .pretendard(.body_14_bold)
                        .foregroundStyle(.gentiGreenNew)
                    
                    Text("세상에 없던\n나만의 사진을 찍고 있어요!")
                        .multilineTextAlignment(.center)
                        .pretendard(.title1_24_bold)
                        .foregroundStyle(.white)
                    Text("사진이 완성되면, 완료 알림을 보내드려요.")
                        .pretendard(.body_14_medium)
                        .foregroundStyle(.white.opacity(0.8))

                } //:VSTACK
                
                Spacer()
                
                LottieView(type: .loading)
                    .looping()
                    .frame(width: 250, height: 250)
                Spacer()
                
                VStack(spacing: 10) {
                    Text("예상 소요시간")
                        .pretendard(.body_14_bold)
                        .foregroundStyle(.white.opacity(0.4))
                    
                    Text("2시간 정도 걸릴 예정이에요.")
                        .pretendard(.subtitle1_18_bold)
                        .foregroundStyle(.white)
                    
                    Text("세상에 하나뿐인 사진을 만들어 드리기 위해\n배경부터 의상까지 꼼꼼하게 준비하고 있어요.")
                        .pretendard(.body_14_bold)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }

                
                Spacer()
                    .frame(height: 30)
                
                GentiPrimaryButton(title: "피드로 돌아가기", isActive: true) {
                    EventLogManager.shared.logEvent(.clickButton(page: .requestCompleted, buttonName: "gomain"))
                    NotificationPermissionCheck.check(completion: { result in
                        if result {
                            self.router.dismissSheet()
                        } else {
                            self.showPushAuthorizationPopUp = true
                        }
                    })
                }
            } //:VSTACK
        } //:ZSTACK
        .toolbar(.hidden, for: .navigationBar)
        .addCustomPopup(isPresented: $showPushAuthorizationPopUp, popupType: .pushAuthorization)
        .customAlert(alertType: $alertType)
        .onReceive(NotificationCenter.default.publisher(for: .init("PopupDismiss"))) { _ in
            self.router.dismissSheet()
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("goToSetting"))) { _ in
            self.alertType = .pushAuthorization(action: { self.router.dismissSheet() })
        }
        
    }
}

#Preview {
    GenerateRequestCompleteView(router: .init())
}



