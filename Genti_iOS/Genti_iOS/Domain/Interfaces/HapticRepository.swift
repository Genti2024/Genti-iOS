//
//  HapticRepository.swift
//  Genti_iOS
//
//  Created by uiskim on 7/5/24.
//

import UIKit

protocol HapticRepository {
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
}
