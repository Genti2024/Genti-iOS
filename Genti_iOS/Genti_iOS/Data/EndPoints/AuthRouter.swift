//
//  AuthRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 7/25/24.
//

import Foundation

import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case kakaoLogin(token: String, fcmToken: String)
    case appleLogin(authorizationCode: String, identityToken: String, fcmToken: String)
    case signIn(sex: String, birthYear: String)
    case reissueToken(token: GentiTokenEntity)
    case logout
    case resign
    
    
    var method: HTTPMethod {
        switch self {
        case .reissueToken, .signIn, .logout, .kakaoLogin, .appleLogin:
            return .post
        case .resign:
            return .delete
        }
    }
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/auth/v1/login/oauth2/token/kakao"
        case .appleLogin:
            return "/auth/v1/login/oauth2/token/apple"
        case .reissueToken:
            return "/auth/v1/reissue"
        case .signIn:
            return "/api/v1/users/signup"
        case .logout:
            return "/api/v1/users/logout"
        case .resign:
            return "/api/v1/users"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case .kakaoLogin(let token, let fcmToken):
            var parameters: [String: Any] = [:]
            parameters["accessToken"] = token
            parameters["fcmToken"] = fcmToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .appleLogin(let authCode, let identityToken, let fcmToken):
            var parameters: [String: Any] = [:]
            parameters["authorizationCode"] = authCode
            parameters["identityToken"] = identityToken
            parameters["fcmToken"] = fcmToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .reissueToken(let token):
            var parameters: [String: Any] = [:]
            parameters["accessToken"] = token.accessToken
            parameters["refreshToken"] = token.refreshToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .signIn(let sex, let birthData):
            var parameters: [String: Any] = [:]
            parameters["birthYear"] = birthData
            parameters["sex"] = sex
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .logout, .resign:
            urlRequest.httpBody = nil
        }

        return urlRequest
    }
    
}
