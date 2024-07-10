//
//  UserRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

import Alamofire

enum UserRouter: URLRequestConvertible {
    
    case fetchMyPictures(page: Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPictures:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchMyPictures:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3MjA1MjQwNDAsImV4cCI6MTIxNzIwNTI0MDQwLCJ1c2VySWQiOiIyIiwicm9sZSI6IlJPTEVfVVNFUiIsInR5cGUiOiJhY2Nlc3MifQ.sty_CcK9lU0_7l0iNLaLt-vycsBpmc032dOr1QgxFe0uyvoaufzA9cghU7NIOHY6T4DK7N_lWVNl_4eCaRbq9w"]
        }
    }

    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .fetchMyPictures:
            return "/api/users/v1/pictures/my"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .fetchMyPictures(let page):
            var parameters: [String: Any] = [:]
            parameters["page"] = page
            parameters["size"] = 10
            parameters["sortBy"] = "createdAt"
            parameters["direction"] = "desc"
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        }
        
        return urlRequest
    }
    
}
