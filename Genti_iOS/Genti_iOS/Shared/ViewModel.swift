//
//  ViewModel.swift
//  Genti_iOS
//
//  Created by uiskim on 6/23/24.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Input

    var state: State { get }
    func sendAction(_ input: Input)
}
