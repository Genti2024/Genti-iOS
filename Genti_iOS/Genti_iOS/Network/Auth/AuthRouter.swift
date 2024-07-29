//
//  AuthRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import Foundation

import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case login(token: String, type: GentiSocialLoginType)
    
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login:
            return .init()
        }
    }

    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login/v1/oauth2/code/apple"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .login(let token, _):
            var parameters: [String: Any] = [:]
            parameters["token"] = token
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }

        return urlRequest
    }
    
}

// MARK: - Response
struct AppleLoginEntity: Codable {
    let userID: Int
    let userName, email: String
    let isNewUser: Bool
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName, email, isNewUser, token
    }
    
    // MARK: - Token
    struct Token: Codable {
        let accessToken, refreshToken: String
    }

}

