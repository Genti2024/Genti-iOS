//
//  Alert.swift
//  Genti_iOS
//
//  Created by uiskim on 7/7/24.
//

import SwiftUI

struct Alert {
    let title: String
    let message: String?
    let actions: [AlertButton]
    let textFieldPlaceholder: String?
    var textFieldText: Binding<String>?
    
    init(title: String, message: String?, actions: [AlertButton], textFieldPlaceholder: String? = nil, textFieldText: Binding<String>? = nil) {
        self.title = title
        self.message = message
        self.actions = actions
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldText = textFieldText
    }
    
    struct AlertButton: Identifiable {
        var id: String { title }
        
        let title: String
        let style: ButtonRole?
        let action: (() -> Void)?
        
        init(title: String, style: ButtonRole? = nil, action: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
}

