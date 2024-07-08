//
//  HapticRepositoryImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import UIKit

final class HapticRepositoryImpl: HapticRepository {
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
