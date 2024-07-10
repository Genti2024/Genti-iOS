//
//  FeedRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 6/30/24.
//

import Foundation

import Alamofire

enum FeedRouter: URLRequestConvertible {
    
    case requestFeed
    
    var method: HTTPMethod {
        switch self {
        case .requestFeed:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .requestFeed:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3MjA1MjQwNDAsImV4cCI6MTIxNzIwNTI0MDQwLCJ1c2VySWQiOiIyIiwicm9sZSI6IlJPTEVfVVNFUiIsInR5cGUiOiJhY2Nlc3MifQ.sty_CcK9lU0_7l0iNLaLt-vycsBpmc032dOr1QgxFe0uyvoaufzA9cghU7NIOHY6T4DK7N_lWVNl_4eCaRbq9w"]
        }
    }
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .requestFeed:
            return "/api/users/examples/v1/with-picture"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
}
