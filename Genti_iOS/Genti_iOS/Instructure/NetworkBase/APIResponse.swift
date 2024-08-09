//
//  APIResponse.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let response: T?
    let errorCode: String?
    let errorMessage: String?
}
