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
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3MjA2ODE1NTEsImV4cCI6MTIxNzIwNjgxNTUxLCJ1c2VySWQiOiIyIiwicm9sZSI6IlJPTEVfVVNFUiIsInR5cGUiOiJhY2Nlc3MifQ.B2v5nNx_wIpWOeKMWR_OBQbg-5v9i0YnCQxrv3O9ydAG7ldJugvH56VnFuisZt9lpaUfNsKRpOOIMpw4oIzPgw"]
        }
    }
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .requestFeed:
            return "/api/v1/users/examples/with-picture"
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
