//
//  Int+Ext.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import Foundation

extension Int {
    func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = numberStyle
        guard let str = numberFommater.string(for: self) else { return "" }
        return str
    }
}
