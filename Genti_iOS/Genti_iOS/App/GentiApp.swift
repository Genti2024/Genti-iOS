//
//  GentiApp.swift
//  Genti_iOS
//
//  Created by uiskim on 6/14/24.
//

import SwiftUI

struct GentiApp: View {

    var body: some View {
        RoutingView(Router<MainRoute>()) { router in
            SplashView(router: router)
                .onNotificationRecieved(name: Notification.Name(rawValue: "PushNotificationReceived")) { _ in
                    router.routeTo(.completeMakeImage)
                    print(#fileID, #function, #line, "- noti received")
                }
        }
    }
}

#Preview {
    GentiApp()
}
