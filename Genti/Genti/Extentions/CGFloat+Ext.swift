//
//  CGFloat+Ext.swift
//  Genti
//
//  Created by uiskim on 4/29/24.
//

import UIKit

extension CGFloat {
    static func height(ratio: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight * ratio
    }
}
