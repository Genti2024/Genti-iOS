//
//  AppDelegate.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import Foundation
import UIKit

import Amplitude
import Firebase
import UserNotifications
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    
    let userdefaultsRepository = UserDefaultsRepositoryImpl()
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: "77d47098298c42fc0400efc76b7f4874")
        
        // 앰플리튜드 설정
        Amplitude.instance().defaultTracking.sessions = true
        Amplitude.instance().initializeApiKey("c107ca36ad5f32ff5d2b8e41eaa161fc")
        
        let identify = AMPIdentify()
            .setOnce("user_share", value: NSNumber(value: 0))
            .setOnce("user_picturedownload", value: NSNumber(value: 0))
            .setOnce("user_main_scroll", value: NSNumber(value: 0))
            .setOnce("user_promptsuggest_refresh", value: NSNumber(value: 0))
        guard let identify = identify else { return true }
        Amplitude.instance().identify(identify)
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "PushNotificationReceived"),
            object: nil,
            userInfo: nil
        )
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        guard let fcmToken = fcmToken else { return }
        userdefaultsRepository.setFcmToken(token: fcmToken)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
