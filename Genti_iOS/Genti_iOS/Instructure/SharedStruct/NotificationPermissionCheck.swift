//
//  NotificationPermissionCheck.swift
//  Genti_iOS
//
//  Created by uiskim on 8/23/24.
//

import UserNotifications

struct NotificationPermissionCheck {
    
    static func check(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .denied, .ephemeral, .notDetermined, .provisional:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
}
