//
//  GenerateCompleteView.swift
//  Genti
//
//  Created by uiskim on 4/22/24.
//

import SwiftUI

struct GenerateRequestCompleteView: View {
    @Bindable var router: Router<MainRoute>
    @State private var showPushAuthorizationPopUp: Bool = false
    @State private var alertType: AlertType? = nil
    var body: some View {
        ZStack {
            
            Color.backgroundWhite
                .ignoresSafeArea()
            
            LinearGradient.backgroundPurple2
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                VStack(spacing: 30) {
                    Image("Genti_LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.isWiderThan375pt ? 60 : 40)
                        .padding(.top, 44)
                    
                    
                    Image("CompleteLabel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    
                    Image("Complete_charactor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.isWiderThan375pt ? 275 : 200)

                } //:VSTACK
                
                Text("예상 소요시간은 2시간입니다")
                    .pretendard(.normal)
                    .foregroundStyle(.black)
                    .padding(.top, 15)
                
                Text("미리 만들어놓은 컨셉에 얼굴만 바꾸는게 아니라\n’나만의 하나뿐인 사진’을 찍어드리기 위해  \n배경부터 의상, 구도까지 꼼꼼하게 준비하고 있어요")
                    .pretendard(.small)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 25)
                
                Spacer(minLength: 0)
                
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
                .padding(.bottom, 30)
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



