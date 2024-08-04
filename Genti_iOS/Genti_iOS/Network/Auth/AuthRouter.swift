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
    case resign
    
    
    var method: HTTPMethod {
        switch self {
        case .login, .reissueToken, .signIn, .logout:
            return .post
        case .resign:
            return .delete
        }
    }
    
    var baseURL: String {
        return "http://ec2-15-165-111-211.ap-northeast-2.compute.amazonaws.com"
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
        case .logout, .resign:
            urlRequest.httpBody = nil
        }

        return urlRequest
    }
    
}
