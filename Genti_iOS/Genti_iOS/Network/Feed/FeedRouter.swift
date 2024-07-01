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
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiYXV0aCI6IlJPTEVfVVNFUiIsImlhdCI6MTcxNzI4MzA4OCwiZXhwIjoxNzc3MjgzMDg4fQ.rP2zPOLydDxUXvKqqNsfXSCxO6q8_O2NxhnE6pcP1WQwQqhouoR4UnVgJAiSxs47VCI7thlzbNvGo9mm-qFNig"]
        }
    }
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .requestFeed:
            return "/api/user/examples/with-picture"
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
