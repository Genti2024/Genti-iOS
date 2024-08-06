//
//  TabViewUseCase.swift
//  Genti_iOS
//
//  Created by uiskim on 8/2/24.
//

import Foundation

protocol TabViewUseCase {
    func getUserState() async throws -> UserState
    func checkCanceledImage(requestId: Int) async throws
    func hasCanceledCase() async throws -> (Bool, Int?)
}
