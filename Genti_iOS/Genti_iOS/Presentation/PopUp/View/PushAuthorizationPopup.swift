//
//  PushAuthorizationPopup.swift
//  Genti_iOS
//
//  Created by uiskim on 8/26/24.
//

import SwiftUI

import PopupView

struct PushAuthorizationPopup: CustomPopup {

    var contentView: some View {
        VStack {
            Image(.pushAuthorization)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 305, height: 257)
                .overlay(alignment: .topTrailing) {
                    Image(.iconsCloseFilled)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .padding(15)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "PopupDismiss"), object: nil)
                        }
                }
                .overlay(alignment: .bottom) {
                    Text("사진 완성 알림 받기")
                        .pretendard(.headline4)
                        .foregroundStyle(.white)
                        .frame(height: 34)
                        .frame(maxWidth: .infinity)
                        .background(.green1)
                        .clipShape(.rect(cornerRadius: 6))
                        .padding(.horizontal, 29.5)
                        .padding(.bottom, 16)
                        .onTapGesture {
                            UNUserNotificationCenter.current().getNotificationSettings { setting in
                                if setting.authorizationStatus == .denied {
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSetting"), object: nil)
                                    }
                                } else {
                                    // 최초엔 일로옴
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow,Error in
                                        DispatchQueue.main.async {
                                            if didAllow { EventLogManager.shared.logEvent(.clickButton(page: .pushAuthorizationAlert, buttonName: "goalarm")) }
                                            EventLogManager.shared.addUserProperty(to: .agreePushNotification(isAgree: didAllow))
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "PopupDismiss"), object: nil)
                                        }
                                    })
                                }
                            }
                        }
                }
            
        }

    }

    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}
