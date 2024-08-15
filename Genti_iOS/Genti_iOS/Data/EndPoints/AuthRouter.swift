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
    case signIn(sex: String, birthData: String)
    case reissueToken(token: GentiTokenEntity)
    case logout
    case resignKakao
    case resignAppleTest(authorizationToken: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .login, .reissueToken, .signIn, .logout, .resignAppleTest:
            return .post
        case .resignKakao:
            return .delete
        }
    }
    
    var baseURL: String {
        return "https://dev.genti.kr"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/v1/login/oauth2/token"
        case .reissueToken:
            return "/auth/v1/reissue"
        case .signIn:
            return "/api/v1/users/signup"
        case .logout:
            return "/api/v1/users/logout"
        case .resignKakao:
            return "/api/v1/users/kakao"
        case .resignAppleTest:
            return "/api/v1/users/apple/sendtoken"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .login(let token, let type):
            var parameters: [String: Any] = [:]
            parameters["token"] = token
            parameters["oauthPlatform"] = type.parameter
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .reissueToken(let token):
            var parameters: [String: Any] = [:]
            parameters["accessToken"] = token.accessToken
            parameters["refreshToken"] = token.refreshToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .signIn(let sex, let birthData):
            var parameters: [String: Any] = [:]
            parameters["birthDate"] = birthData
            parameters["sex"] = sex
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .logout, .resignKakao:
            urlRequest.httpBody = nil
        case .resignAppleTest(let authorizationToken):
            var parameters: [String: Any] = [:]
            parameters["authorizationCode"] = authorizationToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }

        return urlRequest
    }
    
}
