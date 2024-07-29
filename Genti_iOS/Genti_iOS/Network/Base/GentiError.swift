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
    case uploadFail(code: String?, message: String?)
    case unknownedError(code: String?, message: String?)
    case tokenError(code: String?, message: String?)
    
    var code: String? {
        switch self {
        case .emptyResponse(let code, _),
             .serverError(let code, _),
             .clientError(let code, _),
             .uploadFail(let code, _),
             .unknownedError(let code, _),
             .tokenError(let code, _):
            return code
        }
    }
    
    var message: String? {
        switch self {
        case .emptyResponse(_, let message),
             .serverError(_, let message),
             .clientError(_, let message),
             .uploadFail(_, let message),
             .unknownedError(_, let message),
             .tokenError(_, let message):
            return message
        }
    }
    
    var localizedDescription: String {
        return """
        🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥오류 발생🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
        오류 코드    : \(self.code ?? "코드가 안담겨왔음")
        오류 메세지   : \(self.message ?? "메세지가 안담겨왔음")
        """
    }
}
