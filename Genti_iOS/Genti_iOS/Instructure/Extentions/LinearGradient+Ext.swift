//
//  LinearGradient+Ext.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

extension LinearGradient {
    static let borderGreen = LinearGradient(colors: [.gentiGreen, .gentiGreen.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let backgroundPurple1 = LinearGradient(colors: [.gradientPurple2, .gentiPurple.opacity(0)], startPoint: .top, endPoint: .bottom)
    
    static let backgroundPurple2 = LinearGradient(gradient: Gradient(colors: [.gradientPurple1, .gentiPurple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
    
    static let backgroundGreen1 = LinearGradient(colors: [.gentiGreen.opacity(0), .gentiGreen.opacity(1)], startPoint: .top, endPoint: .bottom)
    
    static let backgroundWhite = LinearGradient(colors: [.backgroundWhite, .backgroundWhite.opacity(0)], startPoint: .top, endPoint: .bottom)
    
    static let buttonGreen = LinearGradient(colors: [.buttonGreen1, .buttonGreen2], startPoint: .leading, endPoint: .bottomTrailing)
    
//    static let gentiGradation = Line
}
