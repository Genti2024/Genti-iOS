//
//  GentiError.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Foundation

enum GentiError: Error {
    case emptyResponse(code: String?, message: String?)
    case serverError(code: String?, message: String?)
    case clientError(code: String?, message: String?)
    
    var code: String? {
        switch self {
        case .emptyResponse(let code, _),
             .serverError(let code, _),
             .clientError(let code, _):
            return code
        }
    }
    
    var message: String? {
        switch self {
        case .emptyResponse(_, let message),
             .serverError(_, let message),
             .clientError(_, let message):
            return message
        }
    }
    
    var localizedDescription: String {
        return "Code: \(code ?? "Unknown"), Message: \(message ?? "No message")"
    }
}
