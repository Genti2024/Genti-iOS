//
//  UIScreen+Ext.swift
//  Genti_iOS
//
//  Created by uiskim on 9/12/24.
//

import UIKit

extension UIScreen {
    static var isWiderThan375pt: Bool { UIScreen.main.bounds.width > 375.0 }
}
